module Pronto
  module GolangTools
    class Golint < Base
      def self.base_command
        'golint'
      end

      def parse_line(line)
        path, line_number, _, message = line.split(':')

        absolute_path = Pathname.new(path)
        working_directory = Pathname.new(Dir.pwd)

        file_path = absolute_path.relative_path_from(working_directory).to_s

        return file_path, line_number, :warning, message.to_s.strip
      end
    end
  end
end
