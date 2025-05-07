package main

import (
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func init() {
	if err := godotenv.Load(".env"); err != nil {
		log.Fatal(err)
	}
	// ConnectToDB()mobile
}

func main() {
	r := gin.Default()
	authenticationRouter(r)
	r.Run(":" + os.Getenv("PORT"))
}
