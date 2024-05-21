FROM golang:1.22-alpine

WORKDIR /app

COPY . .

RUN go mod vendor

RUN go mod tidy

RUN go build -o api .

EXPOSE 9000

ENTRYPOINT [ "./api" ]
