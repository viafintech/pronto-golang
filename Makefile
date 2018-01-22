init_gotools:
	go get -u github.com/golang/lint/golint
	go get -u honnef.co/go/tools/cmd/gosimple
	go get -u honnef.co/go/tools/cmd/unused
	go get -u mvdan.cc/unparam
	go get -u github.com/kisielk/errcheck
