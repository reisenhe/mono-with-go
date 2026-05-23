package main

import (
	"log"

	"mono-with-go/api/config"
	"mono-with-go/api/model"
	"mono-with-go/api/router"
)

func main() {
	// Initialize database
	config.InitDB()

	// Auto migrate models
	config.DB.AutoMigrate(&model.User{})

	// Setup router
	r := router.SetupRouter()

	log.Println("Server starting on :8080")
	if err := r.Run(":8080"); err != nil {
		log.Fatal("Failed to start server:", err)
	}
}
