module Pronto
  module GolangTools
  end
end

require_relative './tools/base'

require_relative './tools/golint'
require_relative './tools/gosec'
require_relative './tools/govet'
require_relative './tools/golangci_lint'
require_relative './tools/staticcheck'
