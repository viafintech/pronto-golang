require 'pathname'

require_relative '../errors'

module Pronto
  module GolangTools
    class Gosec < Base

      # Accepts lines of the following format:
      #   [path_to_file:<line_number>] -
      GOSEC_LINE_PATTERN = Regexp.new('^\[(\S+):(\d+)\] - (.+)')

      ANSI_COLOR_CODING_PATTERN = Regexp.new('\e\[\d+(;\d+)?m')

      def self.base_command
        'gosec'
      end

      def command(file_path)
        "#{base_command} #{parameters} #{File.dirname(file_path)}"
      end

      def parse_line(line)
        line = line.gsub(ANSI_COLOR_CODING_PATTERN, '')

        if !GOSEC_LINE_PATTERN.match(line)
          raise ::Pronto::GolangSupport::UnprocessableLine.new(line)
        end

        path        = $1.strip
        line_number = $2.strip
        message     = $3.strip

        absolute_path = Pathname.new(path)
        working_directory = Pathname.new(Dir.pwd)

        file_path = absolute_path.relative_path_from(working_directory)

        return file_path.to_s, line_number, :warning, message
      end
    end
  end
end
