module Pronto
  module GolangTools
    class Base
      def self.base_command
        raise 'base_command needs to be overwritten in inheritance'
      end

      def base_command
        self.class.base_command
      end

      def initialize(config)
        @config = config
      end

      def command(file_path)
        "#{base_command} #{parameters} #{file_path}"
      end

      def parameters
        @config['parameters']
      end

      def available?
        installed? && enabled?
      end

      def installed?
        `which #{base_command}` != ""
      end

      def enabled?
        !!@config['enabled']
      end

      def parse_line(line)
        file_path, line_number, _, message = line.split(':', 4)

        return file_path, line_number, :warning, message.to_s.strip
      end
    end
  end
end
