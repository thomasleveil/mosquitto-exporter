############################
# STEP 1 build executable binary
############################
ARG VERSION=0.5.0
ARG LDFLAGS="-s -w -X main.Version=${VERSION}"

FROM golang:alpine AS builder

COPY . $GOPATH/src/sapcc/mosquitto-exporter/
WORKDIR $GOPATH/src/sapcc/mosquitto-exporter/

# Build the binary.
RUN CGO_ENABLED=0 go build -o /tmp/mosquitto_exporter -ldflags="${LDFLAGS}" sapcc/mosquitto-exporter


############################
# STEP 2 build a small image
############################
FROM scratch

COPY --from=builder /tmp/mosquitto_exporter /mosquitto_exporter

EXPOSE 9234

ENTRYPOINT [ "/mosquitto_exporter" ]
