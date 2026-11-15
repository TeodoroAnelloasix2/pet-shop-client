package httpserver

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"
)

// TestHandleHome verifica l'endpoint "/"
func TestHandleHome(t *testing.T) {
	req, err := http.NewRequest("GET", "/", nil)
	if err != nil {
		t.Fatalf("Impossibile creare la richiesta: %v", err)
	}

	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(HandleHome)
	handler.ServeHTTP(rr, req)

	if status := rr.Code; status != http.StatusOK {
		t.Errorf("HandleHome status sbagliato: got %v want %v", status, http.StatusOK)
	}
	if !strings.Contains(rr.Body.String(), "Welcome") {
		t.Errorf("HandleHome body non contiene 'Welcome': got %v", rr.Body.String())
	}
}

// TestTestHealty verifica l'endpoint "/alive"
func TestTestHealty(t *testing.T) {
	req, _ := http.NewRequest("GET", "/alive", nil)
	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(TestHealty)
	handler.ServeHTTP(rr, req)

	if rr.Code != http.StatusOK {
		t.Errorf("TestHealty ha restituito %v, atteso %v", rr.Code, http.StatusOK)
	}
	if ct := rr.Header().Get("Content-Type"); ct != "application/json" {
		t.Errorf("Content-Type sbagliato: got %v want application/json", ct)
	}
	if !strings.Contains(rr.Body.String(), `"status":"ok"`) {
		t.Errorf("Body non contiene status ok: got %v", rr.Body.String())
	}
}

// TestSayBye verifica l'endpoint "/bye"
func TestSayBye(t *testing.T) {
	req, _ := http.NewRequest("GET", "/bye", nil)
	rr := httptest.NewRecorder()
	handler := http.HandlerFunc(SayBye)
	handler.ServeHTTP(rr, req)

	if rr.Code != http.StatusOK {
		t.Errorf("SayBye ha restituito %v, atteso %v", rr.Code, http.StatusOK)
	}
	if !strings.Contains(rr.Body.String(), "Good bye") {
		t.Errorf("SayBye body non contiene 'Good bye': got %v", rr.Body.String())
	}
}

// TestNewOne verifica l'endpoint "/newone"
// func TestNewOne(t *testing.T) {
// 	req, _ := http.NewRequest("GET", "/newone", nil)
// 	rr := httptest.NewRecorder()
// 	handler := http.HandlerFunc(NewOne)
// 	handler.ServeHTTP(rr, req)

// 	if rr.Code != http.StatusOK {
// 		t.Errorf("NewOne ha restituito %v, atteso %v", rr.Code, http.StatusOK)
// 	}
// 	if !strings.Contains(rr.Body.String(), "Hi from new one") {
// 		t.Errorf("NewOne body non contiene 'Hi from new one': got %v", rr.Body.String())
// 	}
// }
