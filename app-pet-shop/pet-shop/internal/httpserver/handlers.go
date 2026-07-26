package httpserver

import (
	"encoding/json"
	"fmt"
	"net/http"
	"pet-shop/internal/awsrds"
	"pet-shop/internal/formatsecret"
	"pet-shop/internal/secretaws"
	"pet-shop/internal/variables"
	"text/template"
)

var (
	PetShopTemplates = template.Must(template.ParseGlob("/webapp/templates/*"))
)

func HandleHome(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	if err := PetShopTemplates.ExecuteTemplate(w, "home", nil); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}
}

func TestHealty(w http.ResponseWriter, r *http.Request) {
	//TODO check services connections
	w.Header().Set("Content-Type", "application/json")
	if _, err := secretaws.FetchSecret(); err != nil {
		w.WriteHeader(http.StatusServiceUnavailable)
		json.NewEncoder(w).Encode(map[string]string{
			"status":  "unhealty",
			"service": "secret-manager",
			"error":   err.Error(),
		})
		return
	}
	fmt.Println("Step 1, Secretmanager ok ")

	if err := awsrds.CreateCert(); err != nil {
		w.WriteHeader(http.StatusServiceUnavailable)
		json.NewEncoder(w).Encode(map[string]string{
			"status":  "unhealty",
			"service": "rds-cert",
			"error":   err.Error(),
		})
		return
	}
	P, U := formatsecret.PrepareSecret()
	if _, err := awsrds.GetConn(U, P, variables.BundleCertFile); err != nil {
		w.WriteHeader(http.StatusServiceUnavailable)
		json.NewEncoder(w).Encode(map[string]string{
			"status":  "unhealty",
			"service": "rds-connection",
			"error":   err.Error(),
		})
		return
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{
		"status":  "ok",
		"service": "pet-shop",
	})
}
