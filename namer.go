package main

import (
	"encoding/json"
	"net/http"
)

type nameResponse struct {
	Name string `json:"name"`
}

func namerHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	name := nameResponse{
		Name: "world",
	}

	json.NewEncoder(w).Encode(name)
}
