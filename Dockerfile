FROM golang:1.19
#FROM golang:1.14.2-stretch as builder
WORKDIR /go/src/github.com/heptiolabs/gangway

ENV GO111MODULE on

RUN go install github.com/mjibson/esc@latest
COPY . .
RUN esc -o cmd/gangway/bindata.go templates/

RUN go mod verify
RUN CGO_ENABLED=0 GOOS=linux go install -ldflags="-w -s" -v github.com/heptiolabs/gangway/...

FROM alpine:3.9

RUN apk add --no-cache ca-certificates
COPY --from=0 /go/bin/gangway /bin/gangway
