FROM golang:1.22-alpine

WORKDIR /app

COPY . .

RUN go mod vendor

RUN go mod tidy

RUN go build -o api .

EXPOSE 8080

ENTRYPOINT [ "./api" ]
