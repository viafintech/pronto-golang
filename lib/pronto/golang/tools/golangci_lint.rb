module Pronto
  module GolangTools
    class GolangCiLint < Base
      def self.base_command
        'golangci-lint'
      end
    end
  end
end
