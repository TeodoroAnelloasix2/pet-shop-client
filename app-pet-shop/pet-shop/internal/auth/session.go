package auth

import (
	"fmt"
	"net/http"
	"pet-shop/internal/formatsecret"
	"pet-shop/internal/variables"

	"github.com/gorilla/sessions"
)

var (
	SessionSecret = []byte(PrepareSessionValues())
	Store         = sessions.NewCookieStore(SessionSecret)
)

func PrepareSessionValues() (SessionSecret string) {
	s, _ := formatsecret.PrepareSecret()
	return s
}

func Init() {
	Store.Options = &sessions.Options{
		Path:     "/",
		MaxAge:   86400 * 1,
		HttpOnly: true,
		Secure:   false,
		SameSite: http.SameSiteLaxMode,
	}
}
func GetSession(r *http.Request) (*sessions.Session, error) {
	return Store.Get(r, variables.SessionName)
}

func SetUserSession(w http.ResponseWriter, r *http.Request, id int, email, name, surname string) error {
	session, err := Store.Get(r, variables.SessionName)
	if err != nil {
		return fmt.Errorf("error getting session %w", err)
	}
	session.Values["id"] = id
	session.Values["email"] = email
	session.Values["name"] = name
	session.Values["islogged"] = true
	session.Values["surname"] = surname
	return fmt.Errorf("error saving session %w", sessions.Save(r, w))
}

func GetUserSession(r *http.Request) (userData *variables.UserClient, err error) {

	session, err := Store.Get(r, variables.SessionName)
	if err != nil {
		return nil, fmt.Errorf("error getting session: %w", err)
	}
	Islogged, ok := session.Values["islogged"].(bool)
	if !ok || !Islogged {
		return nil, nil
	}
	isLogged, ok := session.Values["is_logged_in"].(bool)
	if !ok || !isLogged {
		return nil, nil
	}
	userData = &variables.UserClient{}
	userData.Islogged = true

	if userID, ok := session.Values["user_id"].(int); ok {
		userData.Id = userID
	}
	if email, ok := session.Values["email"].(string); ok {
		userData.Email = email
	}
	if name, ok := session.Values["name"].(string); ok {
		userData.Name = name
	}
	if surname, ok := session.Values["surname"].(string); ok {
		userData.Surname = surname
	}

	return userData, nil
}

func ClearSession(w http.ResponseWriter, r *http.Request) error {
	session, err := Store.Get(r, variables.SessionName)
	if err != nil {
		return fmt.Errorf("error getting session: %w", err)
	}
	session.Values = make(map[interface{}]interface{})
	session.Options.MaxAge = -1
	return sessions.Save(r, w)
}
