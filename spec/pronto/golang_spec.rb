require 'spec_helper'

module Pronto
  describe Golang do
    let(:golang) { Golang.new(patches) }

    describe '#run' do
      let(:run) { golang.run }

      context 'patches are nil' do
        let(:patches) { nil }

        it 'does not find matches' do
          expect(run).to eq([])
        end
      end

      context 'no patches' do
        let(:patches) { [] }

        it 'does not find matches' do
          expect(run).to eq([])
        end
      end

      context "patches with errors" do
        include_context 'test repo'

        let(:patches) { repo.diff("d14eb84") }

        it "returns errors for all tools" do
          result = golang.run
          expect(result.count).to eq(6)

          # errcheck
          expect(result[0].msg).to eq('Error response given but not checked')
          # golint
          expect(result[1].msg)
            .to eq('exported function ExportedWithoutComment should have comment or be unexported')
          # gosimple
          expect(result[2].msg).to eq('should use for range instead of for { select {} } (S1000)')
          # go vet
          expect(result[3].msg).to eq('unreachable code')
          # unparam
          expect(result[4].msg).to eq('withUnusedParam - result 0 (string) is never used')
          # unused
          expect(result[5].msg).to eq('func ExportedWithoutComment is unused (U1000)')
        end
      end
    end
  end
end
