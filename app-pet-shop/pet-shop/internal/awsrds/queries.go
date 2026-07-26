package awsrds

var (
	CreateTableQuery = `CREATE TABLE users(
		Name varchar(100);
		Surname varchar(100);
		Email varchar(100);
		Password varchar(255);
	);`
)
