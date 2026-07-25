package awsrds

import (
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"pet-shop/internal/variables"
	"strings"
)

func CreateCert() (err error) {

	fmt.Println("Building cert file form ", variables.BundleCertUrl)
	fileUrl, err := url.Parse(variables.BundleCertUrl)
	if err != nil {
		return fmt.Errorf("error parsing url string, %w", err)
	}

	path := fileUrl.Path
	fmt.Println("Path obteined: ", path)
	segments := strings.Split(path, "/")
	fileName := segments[len(segments)-1]

	fmt.Println("File name obtained: ", fileName)
	file, err := os.Create(fileName)
	if err != nil {
		return fmt.Errorf("error creating %s, %w", fileName, err)
	}
	client := http.Client{
		CheckRedirect: func(r *http.Request, via []*http.Request) error {
			r.URL.Opaque = r.URL.Path
			return nil
		},
	}
	resp, err := client.Get(variables.BundleCertUrl)
	if err != nil {
		return fmt.Errorf("error getting url, %w", err)
	}
	defer resp.Body.Close()
	size, err := io.Copy(file, resp.Body)
	defer file.Close()
	fmt.Printf("Downloaded a file %s with size %d\n", fileName, size)
	return nil
}
