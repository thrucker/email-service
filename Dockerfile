FROM golang:alpine as builder

RUN apk add protobuf git
RUN go get -u github.com/micro/protobuf/proto
RUN go get -u github.com/micro/protobuf/protoc-gen-go

WORKDIR /app/shippy-service-email

COPY go.mod ./go.mod
COPY go.sum ./go.sum

RUN go mod download

COPY . .

RUN go generate
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o shippy-service-email main.go

FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

COPY --from=builder /app/shippy-service-email/shippy-service-email .

CMD ["./shippy-service-email"]
