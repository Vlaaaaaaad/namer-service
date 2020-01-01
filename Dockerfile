ARG VENDOR
ARG BUILD_DATE
ARG GIT_REPO
ARG VCS_REF
ARG VERSION
ARG TITLE="namer-service"
ARG DESCRIPTION="PoC that returns a name like 'world' for 'Hello world'"
ARG DOCUMENTATION
ARG AUTHOR
ARG LICENSE="MIT"

FROM golang:1.13-alpine AS builder
LABEL org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.url="${GIT_REPO}" \
    org.opencontainers.image.source="${GIT_REPO}" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.vendor="${VENDOR}" \
    org.opencontainers.image.title="${TITLE}" \
    org.opencontainers.image.description="${DESCRIPTION}" \
    org.opencontainers.image.documentation="${DOCUMENTATION}" \
    org.opencontainers.image.authors="${AUTHOR}" \
    org.opencontainers.image.licenses="${LICENSE}"

RUN apk add --update --no-cache git ca-certificates tzdata && update-ca-certificates

WORKDIR /build

COPY go.mod .
# COPY go.sum .
RUN go mod download && go mod verify

COPY main.go main.go
COPY namer.go namer.go
COPY status.go status.go

RUN go build -o namer

WORKDIR /dist
RUN cp /build/namer ./namer

# FROM scratch AS app fails for some reason
FROM alpine AS app
LABEL org.opencontainers.image.created="${BUILD_DATE}" \
    org.opencontainers.image.url="${GIT_REPO}" \
    org.opencontainers.image.source="${GIT_REPO}" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.revision="${VCS_REF}" \
    org.opencontainers.image.vendor="${VENDOR}" \
    org.opencontainers.image.title="${TITLE}" \
    org.opencontainers.image.description="${DESCRIPTION}" \
    org.opencontainers.image.documentation="${DOCUMENTATION}" \
    org.opencontainers.image.authors="${AUTHOR}" \
    org.opencontainers.image.licenses="${LICENSE}"

COPY --from=builder /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

COPY --from=builder /dist/namer /namer
ENTRYPOINT ["/namer"]
