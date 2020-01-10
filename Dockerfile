ARG buildImage="golang:alpine"
FROM ${buildImage} as builder

RUN apk --no-cache add git

WORKDIR /app/shippy-service-email

COPY go.mod ./go.mod
COPY go.sum ./go.sum

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -installsuffix cgo -o shippy-service-email main.go

FROM alpine:latest as main

RUN apk --no-cache add ca-certificates

WORKDIR /app

COPY --from=builder /app/shippy-service-email/shippy-service-email .

CMD ["./shippy-service-email"]

FROM builder as obj-cache

COPY --from=builder /root/.cache /root/.cache
