package main

import (
	"encoding/json"
	"log"
	"net/http"
)

func respondWithJSON(w http.ResponseWriter, code int, payload interface{}) {
	// encodes the payload into json byte slices 
	data, err := json.Marshal(payload)
	if err != nil {
		w.WriteHeader(500)
		log.Printf("Failed to marshal JSON response: %v", err)
		return
	}

	// Sends a JSON with header and data
	w.Header().Add("Content", "application/json")
	w.WriteHeader(code)
	_, _ = w.Write(data)
}

func respondWithError(w http.ResponseWriter, code int, msg string) {
	if code >= 500 {
		log.Printf("Responding with server error (>500): %v", msg)
	}
	type errResponse struct {
		Error string `json:"error"`
	}

	respondWithJSON(w, code, errResponse{
		msg,
	})
}
