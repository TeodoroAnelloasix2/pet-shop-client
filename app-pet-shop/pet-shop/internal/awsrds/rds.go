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
	dsn := fmt.Sprintf("postgres://%s:%s@pet-shop-psql-bbdd.cqz0qo6cyfkc.us-east-1.rds.amazonaws.com:5432/petshopdb?sslmode=verify-full&sslrootcert=./%s", User, Password, Crt)
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

func PrepareDB(Db *pgx.Conn) (err error) {
	fmt.Println("Preparing database")
	ctx, cancel := ctxgenerator.ContextGenerator()
	defer cancel()
	fmt.Println("Starting transaction")
	tx, err := Db.BeginTx(ctx, pgx.TxOptions{
		IsoLevel:   pgx.ReadCommitted,
		AccessMode: pgx.ReadWrite,
	})
	if err != nil {
		return fmt.Errorf("failed to start transaction %w", err)
	}
	// Rollaback if we get any error
	defer func() {
		if err != nil {

			if txerr := tx.Rollback(ctx); txerr != nil {
				fmt.Println(txerr)
			}
		}
	}()
	fmt.Println("Transaction prepared properly")
	fmt.Println("Creating table Users")
	res, err := tx.Exec(ctx, CreateTableQuery)
	if err != nil {
		return fmt.Errorf("failed to create table %w", err)
	}
	ctx, cancel = ctxgenerator.ContextGenerator()
	defer cancel()
	i := res.RowsAffected()
	fmt.Printf("Table created, affected rows: %d\n", i)
	if err := tx.Commit(ctx); err != nil {
		return fmt.Errorf("failed to execute commit %w", err)
	}
	return nil
}
