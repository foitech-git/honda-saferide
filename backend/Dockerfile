FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o /saferide-api ./cmd/api

FROM alpine:latest

WORKDIR /
COPY --from=builder /saferide-api /saferide-api

EXPOSE 8080

ENTRYPOINT ["/saferide-api"]
