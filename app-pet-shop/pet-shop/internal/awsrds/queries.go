package awsrds

var (
	DopTableQuery    = `DROP TABLE IF EXISTS users;`
	CreateTableQuery = `
	CREATE TABLE users(
		ID SERIAL PRIMARY KEY,
		Name varchar(100),
		Surname varchar(100),
		Email varchar(100),
		Password varchar(255)
	);`
)
