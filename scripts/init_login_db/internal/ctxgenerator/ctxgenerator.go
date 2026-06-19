package ctxgenerator

import (
	"context"
	"time"
)

func ContextGenerator() (context.Context, context.CancelFunc) {
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	return ctx, cancel
}
