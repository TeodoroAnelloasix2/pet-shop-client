package variables

var (
	SecretName = "petshop-db-secret-pem"
)

const (
	VirginiaRegion = "us-east-1"
)

type Credentials struct {
	Username string `json:"Username"`
	Password string `json:"Password"`
}
