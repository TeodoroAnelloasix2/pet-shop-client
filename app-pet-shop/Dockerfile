FROM golang:1.25.5-alpine3.23 AS compiler

WORKDIR /webapp

COPY app/go.mod /webapp/

RUN go mod download

COPY app /webapp/

RUN GOOS=linux GOARCH=amd64 go build -o runner main.go

FROM scratch

WORKDIR /webapp/

COPY --from=compiler /webapp/runner .

EXPOSE 80

CMD ["/webapp/runner"]