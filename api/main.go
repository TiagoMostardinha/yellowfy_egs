package main

import (
	"log"

	. "github.com/TiagoMostardinha/yellowfy_egs/tree/announcements/api/common"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"

	//"net/http"
	"os"
)

var AnnouncementDB Database

func main() {
	// load and check if .env file exists
	err := godotenv.Load()
	if err != nil {
		log.Fatal(".env file not found")
	}

	// gets PORT where our go server will run
	port := os.Getenv("PORT")
	if port == "" {
		log.Fatal("PORT is not found on the enviroment")
	}

	// gets DB_URI where our database will be
	dbURI := os.Getenv("DB_URI")
	if dbURI == "" {
		log.Fatal("DB_URI is not found on the enviroment")
	}

	if err := AnnouncementDB.Connect(dbURI); err != nil {
		log.Fatal("couldn't connect to database")
	}

	defer func() {
		if err := AnnouncementDB.Disconnect(); err != nil {
			log.Fatal("coudn't close database")
		}
	}()

	log.Print("db connected")

	// create a new Router
	router := gin.Default()

	// create version 0 for router
	v0Router := router.Group("/v0")

	// all endpoints present on the api
	v0Router.GET("/healthz", handleReadiness)
	v0Router.GET("/error", handleError)
	v0Router.GET("/", handleGetAnnouncemnts)
	v0Router.GET("/:id", handleGetAnnouncementsByID)
	v0Router.POST("/", handleCreateAnnouncement)
	v0Router.DELETE("/:id", handleDeleteAnnouncement)
	v0Router.PUT("/:id", handleUpdateAnnouncemnt)

	router.Run(":8080")
}
