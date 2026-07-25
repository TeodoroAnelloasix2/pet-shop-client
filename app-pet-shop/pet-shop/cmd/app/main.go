package main

import (
	"fmt"
	"log"
	"os"
	"pet-shop/internal/awsrds"
	"pet-shop/internal/httpserver"
)

func main() {
	err := awsrds.CreateCert()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	srv := httpserver.ServerModel()
	log.Fatal(srv.ListenAndServe())

}
