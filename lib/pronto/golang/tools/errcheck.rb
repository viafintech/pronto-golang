module Pronto
  module GolangTools
    class Errcheck
      def command(file_path)
        "#{base_command} ./..."
      end

      def base_command
        'errcheck'
      end

      def installed?
        `which #{base_command}` != ""
      end

      def parse_line(line)
        file_path, line_number, _, _ = line.split(':')

        return File.expand_path(file_path), line_number, :warning, message
      end

      def message
        'Error response given but not checked'
      end
    end
  end
end
