module Pronto
  module GolangTools
    class Govet < Base
      def self.base_command
        'go vet'
      end

      def available?
        enabled?
      end

      def parse_line(line)
        # Support handling messages like
        # - spec/fixtures/test.git/main.go:18:2: unreachable code
        # - spec/fixtures/test.git/main.go:18: something else
        elements = line.split(':')
        file_path   = elements[0]
        line_number = elements[1]
        message     = elements[-1]

        return file_path, line_number, :warning, message.to_s.strip
      end
    end
  end
end
