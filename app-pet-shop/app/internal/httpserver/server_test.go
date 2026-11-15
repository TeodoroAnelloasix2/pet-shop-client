package httpserver

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestRouter(t *testing.T) {
	router := HandlersPath()

	tests := []struct {
		name         string
		path         string
		expectedCode int
	}{
		{"Home", "/", http.StatusOK},
		{"Alive", "/alive", http.StatusOK},
		{"Bye", "/bye", http.StatusOK},
		//{"NewOne", "/newone", http.StatusOK},
		{"doesntexist", "/example", http.StatusNotFound},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			req, err := http.NewRequest("GET", tt.path, nil)
			if err != nil {
				t.Fatalf("Impossibile creare la richiesta per %s: %v", tt.path, err)
			}

			rr := httptest.NewRecorder()

			router.ServeHTTP(rr, req)

			if rr.Code != tt.expectedCode {
				t.Errorf("Percorso %s: got %v want %v", tt.path, rr.Code, tt.expectedCode)
			}
		})
	}
}

func TestServerModel(t *testing.T) {
	srv := ServerModel()

	if srv.Addr != ":80" {
		t.Errorf("ServerModel Addr: got %v want %v", srv.Addr, ":80")
	}

	if srv.WriteTimeout.Seconds() != 45 {
		t.Errorf("ServerModel WriteTimeout: got %v want 45s", srv.WriteTimeout)
	}

	if srv.ReadTimeout.Seconds() != 45 {
		t.Errorf("ServerModel ReadTimeout: got %v want 45s", srv.ReadTimeout)
	}

	if srv.Handler == nil {
		t.Error("ServerModel Handler non può essere nil")
	}
}
