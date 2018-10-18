require 'open3'
require 'pronto'
require 'yaml'
require 'shellwords'

require_relative './golang/tools'

module Pronto
  class Golang < Runner
    CONFIG_FILE = '.golangtools.yml'
    GOLANG_FILE_EXTENSIONS = ['.go'].freeze

    def run
      return [] unless @patches

      @patches
        .select { |patch| valid_patch?(patch) }
        .map { |patch| inspect(patch) }
        .flatten
        .compact
    end

    def valid_patch?(patch)
      patch.additions > 0 && go_file?(patch.new_file_full_path)
    end

    def inspect(patch)
      escaped_path = Shellwords.escape(patch.new_file_full_path.to_s)

      messages = []

      available_tools.each do |tool|
        Open3.popen3("#{tool.command(escaped_path)}") do |stdin, stdout, stderr, wait_thr|
          [stdout, stderr].each do |result_text|
            while output_line = result_text.gets
              next if output_line.strip == 'exit status 1'

              messages << process_line(patch, tool, output_line)
            end
          end



          while output_line = stderr.gets
            process_line(patch, tool, output_line)
          end
        end
      end

      return messages
    end

    def process_line(patch, tool, output_line)
      return nil if output_line =~ /^#/

      file_path, line_number, severity, message = tool.parse_line(output_line)

      patch.added_lines.each do |line|
        if line_number.to_s == line.new_lineno.to_s &&
           patch.new_file_full_path.to_s == file_path

          return Message.new(
            file_path, line, severity, message, line.commit_sha, self.class
          )
        end
      end

      return nil
    end

    def available_tools
      if @tools == nil
        config = dotconfig

        @tools = GolangTools.constants.sort.map do |constant|
          tool = Object.const_get("Pronto::GolangTools::#{constant}").new

          if tool.installed? &&
             (!config.key?('enabled_tools') ||
              config['enabled_tools'].include?(tool.base_command))

            tool
          else
            nil
          end
        end.compact
      end

      return @tools
    end

    def dotconfig
      if File.exist?(CONFIG_FILE)
        return YAML.load_file(CONFIG_FILE)
      end

      return {}
    end

    def go_file?(path)
      GOLANG_FILE_EXTENSIONS.include?(File.extname(path))
    end
  end
end
