# Pronto runner for Golang

Pronto runner for [Golang](https://golang.org) tools

## Tools

|  Tool    | Install  |
|----------|----------|
| golint   | go get -u github.com/golang/lint/golint |
| gosimple | go get -u honnef.co/go/tools/cmd/gosimple |
| go vet   | - |
| unused   | go get -u honnef.co/go/tools/cmd/unused |
| unparam  | go get -u mvdan.cc/unparam |
| errcheck | go get -u github.com/kisielk/errcheck |

## Enabling only certain tools

In order to only enable certain tools for execution it is possible to provide a `.golangtools.yml` file in the directory of execution.

It looks as follows:
```yaml
enabled_tools:
  - errcheck
  - gosimple
  # ...
```

If the `enabled_tools` is available only the tools in the list will be executed. Note that the tool in question should match the value returned by `base_command`.

## Implementing additional tools

It is possible to add additional tools by adding a new class in the `Pronto::GolangTools` namespace.

It is expected that it reponds to the following methods:

| Method | Description |
|--------|-------------|
| `command(file_path)` | Executes the command and receives the file_path to allow checking only the current file |
| `base_command` | Returns the name/basic command that will be invoked. Is also used for enabling and disabling it via `.golangtools.yml` |
| `installed?` | Returns true if the tool can be found, e.g. through `which #{base_command}` |
| `parse_line(line)` | Receives the line returned from the tool for parsing. REturns `absolute_path`, `line_number`, `level`, `message text` |
