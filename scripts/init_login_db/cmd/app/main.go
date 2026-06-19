package main

import (
	"fmt"
	"os"
	formatsecret "startloginBBDD/internal/formatSecret"
	"startloginBBDD/internal/secretaws"
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
