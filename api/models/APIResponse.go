package models

type APIError struct {
	StatusCode int    `json:"status_code"`
	Message    string `json:"message"`
}

type APIMessage struct {
	StatusCode int    `json:"status_code"`
	Message    string `json:"message"`
}
