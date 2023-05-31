require 'json'

require_relative '../output'

module Pronto
  module GolangTools
    class GolangCiLint < Base
      def self.base_command
        'golangci-lint'
      end

      def execution_mode
        'project'
      end

      def default_parameters
        'run --out-format=json'
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
