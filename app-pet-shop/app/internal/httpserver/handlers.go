package httpserver

import (
	"encoding/json"
	"log"
	"net/http"
)

func HandleHome(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	_, err := w.Write([]byte("Welcome"))
	if err != nil {
		log.Fatalf("error running home function: %v", err)
	}
}

func TestHealty(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{
		"status":  "ok",
		"service": "pet-shop",
		"ready":   "true",
	})
}

func SayBye(w http.ResponseWriter, r *http.Request) {
	_, err := w.Write([]byte("Good bye"))
	if err != nil {
		log.Fatalf("error running bye func: %v", err)
	}
}

func NewOne(w http.ResponseWriter, r *http.Request) {
	_, err := w.Write([]byte("Hi from new one"))
	if err != nil {
		log.Fatalf("error running new func: %v", err)
	}
}
