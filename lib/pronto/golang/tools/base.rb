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
        "cd #{directory} && #{base_command} #{parameters} #{file_path}"
      end

      def directory(default = '.')
        @config.fetch('execution_directory', default)
      end

      def parameters
        @config.fetch('parameters', '') # Default to '' if the key is not configured
      end

      def blacklisted_files_regexp
        @regexp ||= Regexp.new(@config.fetch('blacklisted_files', '^(?!.*)$'))
      end

      def available?
        installed? && enabled?
      end

      def installed?
        `which #{base_command}` != ""
      end

      def enabled?
        @config.fetch('enabled', true) # Default to true if the key is not configured
      end

      # Supported options:
      # - file
      # - project
      def execution_mode
        'file'
      end

      def parse_line(line)
        file_path, line_number, _, message = line.split(':', 4)

        dir = directory('')
        if dir != ''
          file_path = File.join(dir, file_path)
        end

        return file_path, line_number, :warning, message.to_s.strip
      end
    end
  end
end
