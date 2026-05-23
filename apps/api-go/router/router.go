package router

import (
	"github.com/gin-gonic/gin"

	"mono-with-go/api/handler"
	"mono-with-go/api/middleware"
)

func SetupRouter() *gin.Engine {
	r := gin.Default()

	// Global middleware
	r.Use(middleware.CORSMiddleware())

	// API routes
	api := r.Group("/api")
	{
		// Public routes
		api.GET("/health", handler.Health)
		api.POST("/register", handler.Register)
		api.POST("/login", handler.Login)

		// Protected routes
		protected := api.Group("/")
		protected.Use(middleware.AuthMiddleware())
		{
			protected.GET("/profile", handler.GetProfile)
		}
	}

	return r
}
