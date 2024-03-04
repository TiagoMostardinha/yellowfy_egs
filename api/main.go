package main

import (
	//"fmt"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/cors"
	"github.com/joho/godotenv"
	"log"
	"net/http"
	"os"
)

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

	// configures router with the requirements
	router := chi.NewRouter()

	router.Use(cors.Handler(cors.Options{
		AllowedOrigins:   []string{"http://*", "https://*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"*"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: false,
		MaxAge:           300,
	}))

	// Creating a Router for version v0
	v0Router := chi.NewRouter()
	v0Router.Get("/healthz", handlerReadiness)
	v0Router.Get("/error",handlerError)

	router.Mount("/v0", v0Router)

	// configures server to handle requests and response
	server := &http.Server{
		Handler: router,
		Addr:    ":" + port,
	}
	log.Printf("Server starting on port %v", port)

	// starting the server to accept requests and send response
	err = server.ListenAndServe()
	if err != nil {
		log.Fatal(err)
	}
}
