# Pronto runner for Golang

![Build Status](https://github.com/viafintech/pronto-golang/actions/workflows/test.yml/badge.svg) [![RubyDoc](https://img.shields.io/badge/ruby-doc-green.svg)](http://rubydoc.info/github/Barzahlen/pronto-golang)

[Pronto](https://github.com/prontolabs/pronto) runner for [Golang](https://go.dev) tools

## Tools

|  Tool    | Install  |
|----------|----------|
| go vet   | - |
| golint   | go install golang.org/x/lint/golint@latest |
| gosec    | go install github.com/securego/gosec/v2/cmd/gosec@v2.22.8 |
| staticcheck | go install honnef.co/go/tools/cmd/staticcheck@latest |
| golangci-lint v2 | See [Install instructions](https://golangci-lint.run/usage/install/) |

## Configuring tools

In order to configure certain tools for execution it is possible to provide a `.golangtools.yml` file in the directory of execution, any parent directory or `$HOME`.

It looks as follows:
```yaml
tools:
  <tool base command>:
    enabled: true
    parameters: '-v'
    blacklisted_files: '.*\/vendor\/.*'
```

If a tool is not listed here, it will automatically be enabled.
In order to specifically disable a tool, it has to be listed and `enabled` has to be set to `false`.
If either of the keys is not provided the default will be assumed.
It is possible to pass specific parameters to the tool, which is executed with `<tool> <parameters> <file_path>`.
If is also possible to skip handling specific files by providing a pattern in `blacklisted_files`, e.g. `'.*\/vendor\/.*'` to ignore vendor. It will check every file by default.

## Implementing additional tools

It is possible to add additional tools by adding a new class in the `Pronto::GolangTools` namespace.

It is expected that it reponds to the following methods:

| Method | Description |
|--------|-------------|
| `initialize` | Configuration hash from the `.golangtools.yml` config |
| `command(file_path)` | Executes the command and receives the file_path to allow checking only the current file |
| `self.base_command` | Returns the name/basic command that will be invoked. Is also used for enabling and disabling it via `.golangtools.yml` |
| `available?` | Returns true if the tool can be found, e.g. through `which #{base_command}` |
| `process_output(output)` | Receives the output returned from the tool for parsing. Returns an array of `Output` with `absolute_path`, `line_number`, `level`, `message text` |

It is possible to inherit from `Pronto::GolangTools::Base`, in which case only `self.base_command` and `parse_line` need to be implemented.

## Debugging tool output

In order to debug the configured tool output and parsing, it is possible to run pronto with the `PRONTO_GOLANG_DEBUG` environment variable set to `true`, e.g. `PRONTO_GOLANG_DEBUG=true pronto run`. This will print the output of the tool and the parsed messages to the console.

## License

[MIT](LICENSE)
