# syntax=docker/dockerfile:1

##
## Build the application from source
##

FROM golang:1.20 AS build-stage

WORKDIR /app

##
## Copy files
##
COPY go.mod ./
RUN go mod download
RUN mkdir content/
COPY content/index.html ./content/index.html
COPY *.go ./

##
## Build the executable
##
RUN CGO_ENABLED=0 GOOS=linux go build -o /web-demo ./main.go

##
## Run the tests in the container
##

FROM build-stage AS run-test-stage
RUN go test -v ./...

##
## Deploy the application binary into a lean image
##
FROM gcr.io/distroless/base-debian11 AS build-release-stage

WORKDIR /

COPY --from=build-stage /web-demo /web-demo
ADD --from=build-stage /content/index.html /content/index.html

EXPOSE 8000

USER nonroot:nonroot

ENTRYPOINT ["/web-demo"]
