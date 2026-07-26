package main

import (
	"fmt"
	"log"
	"os"
	"pet-shop/internal/awsrds"
	"pet-shop/internal/ctxgenerator"
	"pet-shop/internal/formatsecret"
	"pet-shop/internal/httpserver"
	"pet-shop/internal/variables"
)

func main() {
	fmt.Println("Getting CA file")
	err := awsrds.CreateCert()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	Password, User := formatsecret.PrepareSecret()
	Crt := variables.BundleCertFile
	fmt.Println("Starting db")
	c, err := awsrds.GetConn(User, Password, Crt)

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
