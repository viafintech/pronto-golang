require 'open3'
require 'pronto'
require 'yaml'
require 'shellwords'

require_relative './golang/errors'
require_relative './golang/file_finder'
require_relative './golang/tools'

module Pronto
  class Golang < Runner
    include ::Pronto::GolangSupport::FileFinder

    CONFIG_FILE = '.golangtools.yml'
    GOLANG_FILE_EXTENSIONS = ['.go'].freeze

    def run
      return [] unless @patches

      valid_patches = @patches.select { |patch| valid_patch?(patch) }
      patch_file_paths = valid_patches.map { |patch| patch_file_path(patch) }

      collected_findings = []
      collected_findings += run_tools_for_projects
      collected_findings += run_tools_for_files(patch_file_paths)

      valid_patches
        .map { |patch| inspect(patch, collected_findings) }
        .flatten
        .compact
    end

    def run_tools_for_projects
      collected_findings = []

      available_tools.each do |tool|
        if tool.execution_mode != 'project'
          next
        end

        Open3.popen3("#{tool.command('')}") do |stdin, stdout, stderr, wait_thr|
          [stdout, stderr].each do |result_text|
            while output_line = result_text.gets
              next if output_line.strip == 'exit status 1'

              collected_findings << {
                line: output_line,
                tool: tool,
              }
            end
          end

          while output_line = stderr.gets
            collected_findings << {
              line: output_line,
              tool: tool,
            }
          end
        end
      end

      return collected_findings
    end

    def patch_file_path(patch)
      return Shellwords.escape(patch.new_file_full_path.to_s)
    end

    def run_tools_for_files(filepaths)
      collected_findings = []

      available_tools.each do |tool|
        if tool.execution_mode != 'file'
          next
        end

        filepaths.each do |filepath|
          # Skip the patch if the filepath is blacklisted in the 'blacklisted_files' config
          # Note: this defaults to '.*' and therefore matches everything by default
          if tool.blacklisted_files_regexp.match?(filepath)
            next
          end

          Open3.popen3("#{tool.command(filepath)}") do |stdin, stdout, stderr, wait_thr|
            [stdout, stderr].each do |result_text|
              while output_line = result_text.gets
                next if output_line.strip == 'exit status 1'

                collected_findings << {
                  line: output_line,
                  tool: tool,
                }
              end
            end

            while output_line = stderr.gets
              collected_findings << {
                line: output_line,
                tool: tool,
              }
            end
          end
        end
      end

      return collected_findings
    end

    def valid_patch?(patch)
      patch.additions > 0 && go_file?(patch.new_file_full_path)
    end

    def inspect(patch, findings)
      messages = []

      findings.each do |finding|
        messages << process_line(patch, finding[:tool], finding[:line])
      end

      return messages
    end

    def process_line(patch, tool, output_line)
      return nil if output_line =~ /^#/

      begin
        file_path, line_number, level, message = tool.parse_line(output_line)

        patch.added_lines.each do |line|
          if line_number.to_s == line.new_lineno.to_s &&
             patch.new_file_full_path.to_s == File.expand_path(file_path)

            prefix_message = "#{tool.base_command}: #{message}"

            return Message.new(
              file_path, line, level, prefix_message, line.commit_sha, self.class
            )
          end
        end
      rescue ::Pronto::GolangSupport::UnprocessableLine
        # Do nothing if the line is not processable
      end

      return nil
    end

    def available_tools
      if @tools == nil
        config = dotconfig

        @tools = GolangTools.constants.sort.map do |constant|
          next if constant.to_s == 'Base'

          tool_class = Object.const_get("Pronto::GolangTools::#{constant}")

          tool = tool_class.new(config.fetch('tools').fetch(tool_class.base_command))

          if tool.available?
            tool
          else
            nil
          end
        end.compact
      end

      return @tools
    end

    def dotconfig
      file = find_file_upwards(CONFIG_FILE, Dir.pwd, use_home: true)

      base = {
        'tools' => {}
      }

      if file
        return base.merge(YAML.load_file(file))
      end

      return base
    end

    def go_file?(path)
      GOLANG_FILE_EXTENSIONS.include?(File.extname(path))
    end
  end
end
