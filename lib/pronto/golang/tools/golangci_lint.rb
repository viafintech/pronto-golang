require 'json'

require_relative '../output'

module Pronto
  module GolangTools
    class GolangCiLint < Base
      def self.base_command
        'golangci-lint'
      end

      def self.is_v2?
        v2_command = "golangci-lint --version"
        Open3.popen3(v2_command) do |_stdin, stdout, _stderr, _wait_thr|
          return stdout.gets.include?('version 2')
        end
      end

      def initialize(config)
        @is_v2 = is_v2?
        super(config)
      end

      def execution_mode
        'project'
      end

      def default_parameters
        # golangci lint v2 changed the json flags
        if @is_v2?
          return 'run --output.json.path=stdout --show-stats=false --color=never'
        else
          return 'run --out-format=json'
        end
      end

      def process_output(output)
        issues = JSON.parse(output).fetch('Issues')

        dir = directory('')

        return issues.map do |issue|
          file_path = issue.fetch('Pos').fetch('Filename')

          if dir != ''
            file_path = File.join(dir, file_path)
          end

          Pronto::GolangSupport::Output.new(
            file_path,
            issue.fetch('Pos').fetch('Line'),
            :warning,
            "#{issue.fetch('Text')} (#{issue.fetch('FromLinter')})",
          )
        end
      end
    end
  end
end
