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
            # golangci-lint
            golangci = result.find { |r| r.msg =~ /^golangci-lint: S1000/ }

            expect(golangci.path).to eq('spec/fixtures/test.git/main.go')
            expect(golangci.line.new_lineno).to eq(12)
            expect(golangci.level).to eq(:warning)
            expect(golangci.msg)
              .to eq('golangci-lint: S1000: should use for range instead of for { select {} } (gosimple)')
            expect(golangci.commit_sha).to eq('700d66789fa8a42b368fa890459b033e94d3216d')
            expect(golangci.runner).to eq(Pronto::Golang)

            # golint
            golint = result.find { |r| r.msg =~ /^golint: exported/ }

            expect(golint.path).to eq('spec/fixtures/test.git/main.go')
            expect(golint.line.new_lineno).to eq(21)
            expect(golint.level).to eq(:warning)
            expect(golint.msg)
              .to eq('golint: exported function ExportedWithoutComment should have comment or be unexported')
            expect(golint.commit_sha).to eq('63d374bc2c05b2f5d8a1133b34d943f9da858542')
            expect(golint.runner).to eq(Pronto::Golang)

            # gosec
            gosec = result.find { |r| r.msg =~ /^gosec: G104/ }

            expect(gosec.path).to eq('spec/fixtures/test.git/main.go')
            expect(gosec.line.new_lineno).to eq(18)
            expect(gosec.level).to eq(:warning)
            expect(gosec.msg).to eq('gosec: G104 (CWE-703): Errors unhandled. (Confidence: HIGH, Severity: LOW)')
            expect(gosec.commit_sha).to eq('6456feb6134aee2a2615605274f7ed2d2d1ad84d')
            expect(gosec.runner).to eq(Pronto::Golang)

            # go vet
            govet = result.find { |r| r.msg =~ /^go vet: / }

            expect(govet.path).to eq('spec/fixtures/test.git/main.go')
            expect(govet.line.new_lineno).to eq(18)
            expect(govet.level).to eq(:warning)
            expect(govet.msg).to eq('go vet: unreachable code')
            expect(govet.commit_sha).to eq('6456feb6134aee2a2615605274f7ed2d2d1ad84d')
            expect(govet.runner).to eq(Pronto::Golang)

            # staticcheck
            staticcheck = result.find { |r| r.msg =~ /^staticcheck:.+SA4017/ }

            expect(staticcheck.path).to eq('spec/fixtures/test.git/main.go')
            expect(staticcheck.line.new_lineno).to eq(9)
            expect(staticcheck.level).to eq(:warning)
            expect(staticcheck.msg)
              .to eq(
                'staticcheck: ' \
                'withUnusedParam is a pure function but its return value is ignored (SA4017)'
              )
            expect(staticcheck.commit_sha).to eq('be3fb86b0177ab505c54104c7203c5f107053439')
            expect(staticcheck.runner).to eq(Pronto::Golang)
          end
        end
      end
    end
  end
end
