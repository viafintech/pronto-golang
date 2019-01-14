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

          aggregate_failures do
            expect(result.count).to eq(12)

            # errcheck
            expect(result[0].path).to eq('spec/fixtures/test.git/main.go')
            expect(result[0].line.new_lineno).to eq(18)
            expect(result[0].level).to eq(:warning)
            expect(result[0].msg).to eq('errcheck: Error response given but not checked')
            expect(result[0].commit_sha).to eq('6456feb6134aee2a2615605274f7ed2d2d1ad84d')
            expect(result[0].runner).to eq(Pronto::Golang)
            # golint
            expect(result[1].path).to eq('spec/fixtures/test.git/main.go')
            expect(result[1].line.new_lineno).to eq(21)
            expect(result[1].level).to eq(:warning)
            expect(result[1].msg)
              .to eq('golint: exported function ExportedWithoutComment should have comment or be unexported')
            expect(result[1].commit_sha).to eq('63d374bc2c05b2f5d8a1133b34d943f9da858542')
            expect(result[1].runner).to eq(Pronto::Golang)
            # go vet
            expect(result[2].path).to eq('spec/fixtures/test.git/main.go')
            expect(result[2].line.new_lineno).to eq(18)
            expect(result[2].level).to eq(:warning)
            expect(result[2].msg).to eq('go vet: unreachable code')
            expect(result[2].commit_sha).to eq('6456feb6134aee2a2615605274f7ed2d2d1ad84d')
            expect(result[2].runner).to eq(Pronto::Golang)
            # staticcheck
            expect(result[3].path).to eq('spec/fixtures/test.git/main.go')
            expect(result[3].line.new_lineno).to eq(9)
            expect(result[3].level).to eq(:warning)
            expect(result[3].msg)
              .to eq(
                'staticcheck: ' \
                'withUnusedParam is a pure function but its return value is ignored (SA4017)'
              )
            expect(result[3].commit_sha).to eq('be3fb86b0177ab505c54104c7203c5f107053439')
            expect(result[3].runner).to eq(Pronto::Golang)

            # unparam
            expect(result[9].path).to eq('spec/fixtures/test.git/main.go')
            expect(result[9].line.new_lineno).to eq(30)
            expect(result[9].level).to eq(:warning)
            expect(result[9].msg).to eq('unparam: withUnusedParam - result 0 (string) is never used')
            expect(result[9].commit_sha).to eq('be3fb86b0177ab505c54104c7203c5f107053439')
            expect(result[9].runner).to eq(Pronto::Golang)
            # unused
            expect(result[10].path).to eq('spec/fixtures/test.git/main.go')
            expect(result[10].line.new_lineno).to eq(21)
            expect(result[10].level).to eq(:warning)
            expect(result[10].msg).to eq('unused: func ExportedWithoutComment is unused (U1000)')
            expect(result[10].commit_sha).to eq('63d374bc2c05b2f5d8a1133b34d943f9da858542')
            expect(result[10].runner).to eq(Pronto::Golang)
          end
        end
      end
    end
  end
end
