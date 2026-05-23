package config

import "os"

var JWTSecret = []byte(getEnv("JWT_SECRET", "your-secret-key-change-in-production"))

func getEnv(key, fallback string) string {
	if value, ok := os.LookupEnv(key); ok {
		return value
	}
	return fallback
}
