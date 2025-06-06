package main

import (
	"log"
	"os"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectToDB() {
	dsn := os.Getenv("DB_URL")
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		//if error occures this will break the program
		log.Fatal("Failed to Connect Database")
	}
	//Assigned to DB varaiable
	DB = db
	DB.AutoMigrate(&LoginRequest{})
}
