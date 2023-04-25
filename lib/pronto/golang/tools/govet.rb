module Pronto
  module GolangTools
    class Govet < Base
      def self.base_command
        'go vet'
      end

      def available?
        enabled?
      end
    end
  end
end
