init_gotools:
	go install golang.org/x/lint/golint@latest
	go install honnef.co/go/tools/cmd/staticcheck@latest
	go install github.com/securego/gosec/v2/cmd/gosec@v2.22.8
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b ${GOPATH}/bin v2.4.0
