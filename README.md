# Pronto runner for Golang

[![Build Status](https://travis-ci.org/Barzahlen/pronto-golang.svg?branch=master)](https://travis-ci.org/Barzahlen/pronto-golang) [![RubyDoc](https://img.shields.io/badge/ruby-doc-green.svg)](http://rubydoc.info/github/Barzahlen/pronto-golang)

Pronto runner for [Golang](https://golang.org) tools

## Tools

|  Tool    | Install  |
|----------|----------|
| golint   | go get -u golang.org/x/lint/golint |
| gosimple | go get -u honnef.co/go/tools/cmd/gosimple |
| go vet   | - |
| unused   | go get -u honnef.co/go/tools/cmd/unused |
| unparam  | go get -u mvdan.cc/unparam |
| errcheck | go get -u github.com/kisielk/errcheck |

## Configuring tools

In order to configure certain tools for execution it is possible to provide a `.golangtools.yml` file in the directory of execution, any parent directory or `$HOME`.

It looks as follows:
```yaml
tools:
  <tool base command>:
    enabled: true
    parameters: './...'
```

If a tool is not listed here, it will automatically be enabled with the parameters `./...`.
In order to specifically disable a tool, it has to be listed and `enabled` has to be set to `false`.
If either of the keys is not provided the default will be assumed.

## Implementing additional tools

It is possible to add additional tools by adding a new class in the `Pronto::GolangTools` namespace.

It is expected that it reponds to the following methods:

| Method | Description |
|--------|-------------|
| `initialize` | Configuration hash from the `.golangtools.yml` config |
| `command(file_path)` | Executes the command and receives the file_path to allow checking only the current file |
| `self.base_command` | Returns the name/basic command that will be invoked. Is also used for enabling and disabling it via `.golangtools.yml` |
| `available?` | Returns true if the tool can be found, e.g. through `which #{base_command}` |
| `parse_line(line)` | Receives the line returned from the tool for parsing. Returns `absolute_path`, `line_number`, `level`, `message text` |

It is possible to inherit from `Pronto::GolangTools::Base`, in which case only `self.base_command` and `parse_line` need to be implemented.

## License

[MIT](LICENSE)
