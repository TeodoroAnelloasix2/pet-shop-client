package formatsecret

import (
	"encoding/json"
	"fmt"
	"startloginBBDD/internal/variables"
)

func Formatsecret(txt string) (cred variables.Credentials, err error) {

	err = json.Unmarshal([]byte(txt), &cred)
	if err != nil {
		return variables.Credentials{}, fmt.Errorf("error parsing data, %v", err)
	}
	return cred, nil
}
