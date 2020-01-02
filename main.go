package main

import (
	"log"
	"net/http"
)

func setServiceHeader(h http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("X-Reply-Service", "namer-service")
		h.ServeHTTP(w, r)
	})
}

func main() {
	globalmux := http.NewServeMux()

	globalmux.HandleFunc("/", namerHandler)
	globalmux.HandleFunc("/status/alive", aliveHandler)
	globalmux.HandleFunc("/status/ready", readyHandler)

	log.Fatal(http.ListenAndServe(":5003", setServiceHeader(globalmux)))
}
