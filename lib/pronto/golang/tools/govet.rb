module Pronto
  module GolangTools
    class Govet
      def command(file_path)
        "#{base_command} ./..."
      end

      def base_command
        'go vet'
      end

      def installed?
        true
      end

      def parse_line(line)
        file_path, line_number, message = line.split(':')

        [file_path, line_number, :warning, message.strip]
      end
    end
  end
end
