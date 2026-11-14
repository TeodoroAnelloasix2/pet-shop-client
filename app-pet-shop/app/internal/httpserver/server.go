package httpserver

import (
	"net/http"
	"time"

	"github.com/gorilla/mux"
)

func HandlersPath() *mux.Router {
	router := mux.NewRouter()
	router.HandleFunc("/", HandleHome)
	router.HandleFunc("/alive", TestHealty)
	router.HandleFunc("/bye", SayBye)
	return router
}

func ServerModel() *http.Server {
	mx := HandlersPath()
	srv := &http.Server{
		Addr:              ":80",
		WriteTimeout:      time.Duration(45) * time.Second,
		ReadTimeout:       time.Duration(45) * time.Second,
		ReadHeaderTimeout: time.Duration(30) * time.Second,
		Handler:           mx,
		IdleTimeout:       time.Duration(600) * time.Second,
		MaxHeaderBytes:    1 << 20, // 1MB
	}
	return srv
}
