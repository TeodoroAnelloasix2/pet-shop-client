FROM golang:1.25.5-alpine3.23 AS compiler

WORKDIR /webapp

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY ./cmd  ./cmd
COPY ./internal ./internal

RUN GOOS=linux GOARCH=amd64 go build -o runner cmd/app/main.go

FROM debian:trixie

WORKDIR /webapp

COPY ./resources .
COPY --from=compiler /webapp/runner /webapp/runner

RUN apt update && apt install curl jq ca-certificates -y && update-ca-certificates

EXPOSE 80
#CMD ["sh","-c","tail -f","/dev/null"] #Debug
CMD [ "/webapp/runner"]