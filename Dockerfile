ARG VENDOR
ARG BUILD_DATE
ARG GIT_REPO
ARG VCS_REF
ARG VERSION=dev
ARG TITLE="namer-service"
ARG DESCRIPTION="PoC that returns a name like 'world' for 'Hello world'"
ARG DOCUMENTATION
ARG AUTHOR
ARG LICENSE="MIT"

FROM golang:1.14.7-buster AS builder
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

WORKDIR /build

COPY go.mod .
COPY go.sum .
RUN go mod download && go mod verify

ADD . .

RUN go build \
  -ldflags "-X main.BuildID=${VERSION}" \
  -o namer ./cmd/namer

WORKDIR /dist
RUN cp /build/namer ./namer

# FROM scratch AS app fails for some reason
FROM ubuntu:focal-20200720 AS app
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

COPY --from=builder /dist/namer /namer
ENTRYPOINT ["/namer"]
