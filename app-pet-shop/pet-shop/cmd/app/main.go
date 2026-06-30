package main

import (
	"log"
	"pet-shop/internal/httpserver"
)

func main() {

	srv := httpserver.ServerModel()
	log.Fatal(srv.ListenAndServe())

}
