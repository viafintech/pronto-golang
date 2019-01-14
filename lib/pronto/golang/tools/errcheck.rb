module Pronto
  module GolangTools
    class Errcheck < Base
      def self.base_command
        'errcheck'
      end

      def parse_line(line)
        file_path, line_number, _, _ = line.split(':')

        return file_path, line_number, :warning, message
      end

      def message
        'Error response given but not checked'
      end
    end
  end
end
