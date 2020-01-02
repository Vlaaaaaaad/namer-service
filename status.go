package main

import (
	"encoding/json"
	"net/http"
)

type statusResponse struct {
	Status string `json:"status"`
}

func aliveHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	status := statusResponse{
		Status: "Greeter service is alive",
	}

	json.NewEncoder(w).Encode(status)
}

func readyHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	status := statusResponse{
		Status: "Greeter service is healthy",
	}

	json.NewEncoder(w).Encode(status)
}
