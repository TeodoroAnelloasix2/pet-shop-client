package main

import (
	"fmt"
	"log"
	"os"
	"pet-shop/internal/awsrds"
	"pet-shop/internal/ctxgenerator"
	"pet-shop/internal/httpserver"
)

func main() {
	fmt.Println("Getting CA file")
	err := awsrds.CreateCert()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	fmt.Println("Starting db")
	c, err := awsrds.GetConn()

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	ctx, cancel := ctxgenerator.ContextGenerator()
	defer cancel()
	defer c.Close(ctx)
	err = awsrds.PrepareDB(c, awsrds.DopTableQuery)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	err = awsrds.PrepareDB(c, awsrds.CreateTableQuery)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	srv := httpserver.ServerModel()
	log.Fatal(srv.ListenAndServe())

}
