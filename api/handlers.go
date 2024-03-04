package main

import "net/http"

// Handler to test if the api is running
func handlerReadiness(w http.ResponseWriter, r *http.Request) {
	respondWithJSON(w, 200, struct{}{})
}

// Handle for errors
func handlerError(w http.ResponseWriter, r *http.Request) {
	respondWithError(w, 400, "Something went wrong")
}
