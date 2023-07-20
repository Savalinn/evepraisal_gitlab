FROM golang:1.19-alpine as builder
LABEL maintainer="sudorandom <https://github.com/evepraisal/go-evepraisal>"
WORKDIR $GOPATH/src/github.com/evepraisal/go-evepraisal
RUN apk --update add --no-cache --virtual build-dependencies git gcc musl-dev make bash && \
    git clone https://github.com/Mischahe/go-evepraisal.git . && \
    export GO119MODULE=on ENV=prod && \
    make setup && \
    make build && \
    make install && \
    mv $GOPATH/bin/evepraisal /evepraisal

FROM alpine:latest
RUN mkdir -p /evepraisal/db
COPY --from=builder /evepraisal /evepraisal
VOLUME /evepraisal/db
WORKDIR /evepraisal
CMD ["./evepraisal"]
