FROM ruby:2.5

ENV GOLANG_VERSION 1.10

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
RUN go get -u golang.org/x/lint/golint
RUN go get -u honnef.co/go/tools/cmd/gosimple
RUN go get -u honnef.co/go/tools/cmd/unused
RUN go get -u mvdan.cc/unparam
RUN go get -u github.com/kisielk/errcheck

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN gem install bundle

COPY . /usr/src/app

RUN bundle install --jobs 4 --retry 3
