# frozen_string_literal: true

require 'spec_helper'

module Pronto
  module GolangTools

    describe Base do
      let(:config) do
        {}
      end

      let(:base) do
        described_class.new(config)
      end

      describe '#directory' do
        context 'when nothing is configured' do
          context 'without parameter' do
            it "returns '.'" do
              expect(base.directory).to eq('.')
            end
          end

          context 'with parameter' do
            it 'returns an empty string' do
              expect(base.directory('')).to eq('')
            end
          end
        end

        context 'when execution_directory is configured' do
          let(:config) do
            {
              'execution_directory' => '/tmp',
            }
          end

          context 'without parameter' do
            it 'returns the configured value' do
              expect(base.directory).to eq('/tmp')
            end
          end

          context 'with parameter' do
            it 'returns the configured value' do
              expect(base.directory('')).to eq('/tmp')
            end
          end
        end
      end

      describe '#parameters' do
        context 'without parameters configured' do
          it 'returns an empty string' do
            expect(base.parameters).to eq('')
          end
        end

        context 'with parameters configured' do
          let(:config) do
            {
              'parameters' => 'run',
            }
          end

          it 'returns the configured value' do
            expect(base.parameters).to eq('run')
          end
        end
      end

      describe '#enabled?' do
        context 'without parameters configured' do
          it 'returns true by default' do
            expect(base.enabled?).to eq(true)
          end
        end

        context 'with enabled configured' do
          let(:config) do
            {
              'enabled' => false,
            }
          end

          it 'returns the configured value' do
            expect(base.enabled?).to eq(false)
          end
        end
      end

      describe '#execution_mode' do
        it 'defaults to file' do
          expect(base.execution_mode).to eq('file')
        end
      end

      describe '#parse_line' do
        [
          {
            line:   'spec/fixtures/test.git/main.go:18:2: unreachable code',
            values: ['spec/fixtures/test.git/main.go', '18', :warning, 'unreachable code'],
          },
          {
            line:   'spec/fixtures/test.git/main.go:18: something else',
            values: ['spec/fixtures/test.git/main.go', '18', :warning, 'something else'],
          },
          {
            line:   'main.go:21:40: Comment should end in a period (godot)',
            values: ['main.go', '21', :warning, 'Comment should end in a period (godot)'],
          },
          {
            line:   'long/line.go:21: line is 121 characters (lll)',
            values: ['long/line.go', '21', :warning, 'line is 121 characters (lll)'],
          },
          {
            line:   'long/line.go:21: S1000: should use for range instead of for { select {} }',
            values: [
              'long/line.go',
              '21',
              :warning,
              'S1000: should use for range instead of for { select {} }',
            ],
          },
          {
            line:   'long/line.go:21:12: S1000: should use for range instead of for { select {} }',
            values: [
              'long/line.go',
              '21',
              :warning,
              'S1000: should use for range instead of for { select {} }',
            ],
          },
        ].each do |test_case|
          it "parses line '#{test_case[:line]}' correctly" do
            expect(base.parse_line(test_case[:line])).to eq(test_case[:values])
          end
        end
      end
    end

  end
end
