FROM golang:1.25.5-alpine3.23 AS compiler

WORKDIR /webapp

COPY app/go.mod /webapp/

RUN go mod download

COPY app /webapp/

RUN go test ./... -v
RUN GOOS=linux GOARCH=amd64 go build -o runner main.go

FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -u 1000 -m -d /home/appuser -s /bin/bash appuser

USER appuser

WORKDIR /webapp/

COPY --from=compiler /webapp/runner .

EXPOSE 80

CMD ["/webapp/runner"]