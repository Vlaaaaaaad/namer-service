package main

import (
	"fmt"
	"net/http"
)

func namerHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "world")
}
