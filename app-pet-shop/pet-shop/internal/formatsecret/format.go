package formatsecret

import (
	"encoding/json"
	"fmt"
	"os"
	"pet-shop/internal/secretaws"
	"pet-shop/internal/variables"
)

func Formatsecret(txt string) (cred variables.Credentials, err error) {

	err = json.Unmarshal([]byte(txt), &cred)
	if err != nil {
		return variables.Credentials{}, fmt.Errorf("error parsing data, %v", err)
	}
	return cred, nil
}

func PrepareSecret() (P string, U string) {
	fmt.Println("Retrieving secrets")
	sct, err := secretaws.FetchSecret()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	fmt.Println("Secret successfully retrieved")
	cred, err := Formatsecret(sct)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	P = cred.Password
	U = cred.Username
	return P, U
}
