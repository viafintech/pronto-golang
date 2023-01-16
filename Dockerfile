FROM ruby:2.7

ENV GOLANG_VERSION 1.19

RUN curl -sSL https://dl.google.com/go/go$GOLANG_VERSION.linux-amd64.tar.gz \
                | tar -C /usr/local -xz

RUN apt-get update && \
    apt-get install -y cmake --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

ENV PATH /usr/local/go/bin:$PATH

RUN mkdir -p /go/src /go/bin && chmod -R 777 /go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

# gotools
RUN go install golang.org/x/lint/golint@latest
RUN go install honnef.co/go/tools/cmd/staticcheck@latest
ENV GOLANGCI_LINT_VERSION v1.50.1
RUN curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin $GOLANGCI_LINT_VERSION

ENV GOSEC_VERSION 2.14.0
RUN go install github.com/securego/gosec/v2/cmd/gosec@v$GOSEC_VERSION

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN gem install bundle

COPY . /usr/src/app

RUN bundle install --jobs 4 --retry 3
