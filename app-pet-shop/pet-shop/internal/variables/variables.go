package variables

var (
	SecretName     = "petshop-db-secret-pem"
	BundleCertUrl  = "https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem"
	BundleCertFile = "global-bundle.pem"
)

const (
	VirginiaRegion = "us-east-1"
	SessionName    = "pet-shop-session"
)

type Credentials struct {
	Username string `json:"Username"`
	Password string `json:"Password"`
}

type UserClient struct {
	Id       int
	Name     string
	Surname  string
	Email    string
	Password string
	Islogged bool
}
