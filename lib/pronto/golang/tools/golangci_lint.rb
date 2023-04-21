module Pronto
  module GolangTools
    class GolangCiLint < Base
      def self.base_command
        'golangci-lint'
      end

      def execution_mode
        'project'
      end
    end
  end
end
