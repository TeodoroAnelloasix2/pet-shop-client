package awsrds

import (
	"fmt"
	"os"
	"pet-shop/internal/ctxgenerator"
	"pet-shop/internal/formatsecret"
	"pet-shop/internal/secretaws"
	"pet-shop/internal/variables"

	pgx "github.com/jackc/pgx/v5"
)

func GetConn() (*pgx.Conn, error) {
	fmt.Println("Retrieving secrets")
	sct, err := secretaws.FetchSecret()
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	fmt.Println("Secret successfully retrieved")
	cred, err := formatsecret.Formatsecret(sct)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	fmt.Println("Preparing connection to database")
	Password := cred.Password
	User := cred.Username
	Crt := variables.BundleCertFile
	dsn := fmt.Sprintf("postgres://%s:%s@pet-shop-psql-bbdd.cqz0qo6cyfkc.us-east-1.rds.amazonaws.com:5432/petshopdb?sslmode=verify-full&sslrootcert=./%s", Crt, User, Password)
	ctx, cancel := ctxgenerator.ContextGenerator()
	defer cancel()
	conn, err := pgx.Connect(ctx, dsn)

	if err != nil {
		return nil, fmt.Errorf("error creating connection to rds db %w", err)
	}

	fmt.Println("Testing connection")

	ctx, cancel = ctxgenerator.ContextGenerator()
	if err = conn.Ping(ctx); err != nil {
		return nil, fmt.Errorf("error establishing connection %w", err)
	}
	fmt.Println("Connection established properly")
	return conn, nil

}
