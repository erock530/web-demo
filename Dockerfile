FROM golang

ADD . /go/src/github.com/erock530/web-demo

RUN go install github.com/erock530/web-demo

ADD ./content /content

ENTRYPOINT /go/bin/web-demo
