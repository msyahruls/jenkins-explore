FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY . .

RUN go mod tidy
RUN go build -o app 

FROM debian:bookworm-slim

RUN apt-get update && apt-get upgrade -y && apt-get clean

WORKDIR /app
COPY --from=builder /app/app .

CMD ["./app"]