package awsrds

import (
	"fmt"
	"pet-shop/internal/ctxgenerator"

	pgx "github.com/jackc/pgx/v5"
)

func GetConn(User, Password, Crt string) (*pgx.Conn, error) {

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

func PrepareDB(Db *pgx.Conn, Query string) (err error) {
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
	fmt.Println("Executing query: ", Query)
	res, err := tx.Exec(ctx, Query)
	if err != nil {
		return fmt.Errorf("failed to execute query %w", err)
	}
	ctx, cancel = ctxgenerator.ContextGenerator()
	defer cancel()
	i := res.RowsAffected()
	fmt.Printf("Affected rows: %d\n", i)
	if err := tx.Commit(ctx); err != nil {
		return fmt.Errorf("failed to execute commit %w", err)
	}
	return nil
}
