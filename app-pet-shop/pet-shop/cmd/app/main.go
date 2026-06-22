package main

import (
	"fmt"
	"os"
	"pet-shop/internal/formatsecret"
	"pet-shop/internal/secretaws"
)

func main() {

	fmt.Println("Retrieving secrets")
	secrets, err := secretaws.FetchSecret()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	Credentials, err := formatsecret.Formatsecret(secrets)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	fmt.Println(Credentials.Username, Credentials.Password)
}
