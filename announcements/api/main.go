package main

import (
	"log"

	. "github.com/TiagoMostardinha/yellowfy_egs/tree/announcements/api/common"
	_ "github.com/TiagoMostardinha/yellowfy_egs/tree/announcements/api/docs"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"

	"os"
)

// @title	Announcements service API
// @version	1.0
// @description	This is the API for the announcements service in GO with Gin Framework.

// @host	grupo6-egs-deti.ua.pt/announcements
// @BasePath	/v1

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

	announcementsRouter := router.Group("/announcements")

	// adds swagger documentation
	announcementsRouter.GET("/docs/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	// create version 0 for router
	v1Router := announcementsRouter.Group("/v1")

	// all endpoints present on the api
	v1Router.GET("/healthz", handleReadiness)
	v1Router.GET("/", handleGetAnnouncemnts)
	v1Router.GET("/:id", handleGetAnnouncementsByID)
	v1Router.POST("/", handleCreateAnnouncement)
	v1Router.DELETE("/:id", handleDeleteAnnouncement)
	v1Router.PUT("/:id", handleUpdateAnnouncemnt)

	err = router.Run(":" + port)
	if err != nil {
		log.Fatal(err)
	}
}
