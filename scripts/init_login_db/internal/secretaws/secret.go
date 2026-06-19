package secretaws

import (
	"fmt"
	"startloginBBDD/internal/ctxgenerator"
	v "startloginBBDD/internal/variables"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/secretsmanager"
)

func FetchSecret() (secrets string, err error) {
	ctx, c := ctxgenerator.ContextGenerator()
	defer c()
	cfg, err := config.LoadDefaultConfig(ctx, config.WithRegion(v.VirginiaRegion)) //TODO create AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
	if err != nil {
		return "", fmt.Errorf("error creating session: %v\n", err)

	}
	svc := secretsmanager.NewFromConfig(cfg)
	input := &secretsmanager.GetSecretValueInput{
		SecretId:     aws.String(v.SecretName),
		VersionStage: aws.String("AWSCURRENT"),
	}
	ctx, c = ctxgenerator.ContextGenerator()
	defer c()
	res, err := svc.GetSecretValue(ctx, input)
	if err != nil {
		return "", fmt.Errorf("error retrieving secrets values, %v\n", err)

	}
	fmt.Printf("Retrieved secret: %s\nCreated at: %s\n", *res.ARN, res.CreatedDate.Format("2006-01-02 15:04:05"))
	return *res.SecretString, nil
}
