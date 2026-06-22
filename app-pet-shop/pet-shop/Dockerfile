FROM golang:1.25.5-alpine3.23 AS compiler

WORKDIR /webapp

COPY go.mod .
COPY go.sum .
RUN go mod download

COPY ./cmd  ./cmd
COPY ./internal ./internal

RUN GOOS=linux GOARCH=amd64 go build -o runner cmd/app/main.go

FROM scratch

WORKDIR /webapp

COPY --from=compiler /webapp/runner /webapp/runner

EXPOSE 80

CMD [ "/webapp/runner" ]