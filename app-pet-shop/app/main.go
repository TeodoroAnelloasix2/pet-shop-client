package main

import (
	"log"
	"petshopapp/internal/httpserver"
)

func main() {
	srv := httpserver.ServerModel()
	log.Fatal(srv.ListenAndServe())
}
