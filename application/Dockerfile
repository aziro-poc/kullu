FROM golang:1.22 AS builder
WORKDIR /app

# Ensure static binary
ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

COPY . .
RUN go mod tidy
RUN go build -o app .

FROM scratch
WORKDIR /
COPY --from=builder /app/app /app
ENTRYPOINT ["/app"]