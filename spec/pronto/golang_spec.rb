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
            expect(result.count).to eq(16)

            # golangci-lint
            expect(result[5].path).to eq('spec/fixtures/test.git/main.go')
            expect(result[5].line.new_lineno).to eq(12)
            expect(result[5].level).to eq(:warning)
            expect(result[5].msg)
              .to eq('golangci-lint: S1000: should use for range instead of for { select {} } (gosimple)')
            expect(result[5].commit_sha).to eq('700d66789fa8a42b368fa890459b033e94d3216d')
            expect(result[5].runner).to eq(Pronto::Golang)

            # golint
            expect(result[6].path).to eq('/usr/src/app/spec/fixtures/test.git/main.go')
            expect(result[6].line.new_lineno).to eq(21)
            expect(result[6].level).to eq(:warning)
            expect(result[6].msg)
              .to eq('golint: exported function ExportedWithoutComment should have comment or be unexported')
            expect(result[6].commit_sha).to eq('63d374bc2c05b2f5d8a1133b34d943f9da858542')
            expect(result[6].runner).to eq(Pronto::Golang)
            # gosec
            expect(result[7].path).to eq('spec/fixtures/test.git/main.go')
            expect(result[7].line.new_lineno).to eq(18)
            expect(result[7].level).to eq(:warning)
            expect(result[7].msg).to eq('gosec: G104: Errors unhandled. (Confidence: HIGH, Severity: LOW)')
            expect(result[7].commit_sha).to eq('6456feb6134aee2a2615605274f7ed2d2d1ad84d')
            expect(result[7].runner).to eq(Pronto::Golang)
            # go vet
            expect(result[8].path).to eq('spec/fixtures/test.git/main.go')
            expect(result[8].line.new_lineno).to eq(18)
            expect(result[8].level).to eq(:warning)
            expect(result[8].msg).to eq('go vet: unreachable code')
            expect(result[8].commit_sha).to eq('6456feb6134aee2a2615605274f7ed2d2d1ad84d')
            expect(result[8].runner).to eq(Pronto::Golang)
            # staticcheck
            expect(result[9].path).to eq('spec/fixtures/test.git/main.go')
            expect(result[9].line.new_lineno).to eq(9)
            expect(result[9].level).to eq(:warning)
            expect(result[9].msg)
              .to eq(
                'staticcheck: ' \
                'withUnusedParam is a pure function but its return value is ignored (SA4017)'
              )
            expect(result[9].commit_sha).to eq('be3fb86b0177ab505c54104c7203c5f107053439')
            expect(result[9].runner).to eq(Pronto::Golang)
          end
        end
      end
    end
  end
end
