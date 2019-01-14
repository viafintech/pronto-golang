module Pronto
  module GolangTools
    class Golint < Base
      def self.base_command
        'golint'
      end

      def parse_line(line)
        file_path, line_number, _, message = line.split(':')

        return file_path, line_number, :warning, message.to_s.strip
      end
    end
  end
end
