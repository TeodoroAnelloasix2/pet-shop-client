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
	return router
}

func ServerModel() *http.Server {

	mx := HandlersPath()
	ParseResourcesTemplates(mx)
	srv := &http.Server{
		Addr:              ":80",
		WriteTimeout:      time.Duration(30) * time.Second,
		ReadTimeout:       time.Duration(45) * time.Second,
		ReadHeaderTimeout: time.Duration(30) * time.Second,
		Handler:           mx,
		IdleTimeout:       time.Duration(60) * time.Second,
		MaxHeaderBytes:    1 << 20, // 1 MB
	}
	return srv
}

func ParseResourcesTemplates(mx *mux.Router) {
	s := http.StripPrefix("/webapp/templates", http.FileServer(http.Dir("/webapp/templates")))
	mx.PathPrefix("/webapp/templates").Handler(s)
}
