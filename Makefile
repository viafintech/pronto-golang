init_gotools:
	go get -u golang.org/x/lint/golint
	go get -u honnef.co/go/tools/cmd/staticcheck
	curl -sfL https://raw.githubusercontent.com/securego/gosec/master/install.sh | sh -s -- -b ${GOPATH}/bin 2.0.0
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.28.3
