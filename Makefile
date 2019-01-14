init_gotools:
	go get -u golang.org/x/lint/golint
	go get -u honnef.co/go/tools/cmd/staticcheck
	go get -u honnef.co/go/tools/cmd/unused
	go get -u mvdan.cc/unparam
	go get -u github.com/kisielk/errcheck
