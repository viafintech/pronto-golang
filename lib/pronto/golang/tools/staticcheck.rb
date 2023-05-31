require_relative '../output'

module Pronto
  module GolangTools
    class Staticcheck < Base
      def self.base_command
        'staticcheck'
      end

      def process_output(output)
        file_path, line_number, _, message = output.split(':')

        return [
          Pronto::GolangSupport::Output.new(file_path, line_number, :warning, message.to_s.strip),
        ]
      end
    end
  end
end
