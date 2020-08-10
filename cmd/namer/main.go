package main

import (
	"log"
	"net/http"

	"github.com/vlaaaaaaad/namer-service/internal/namer"
	"github.com/vlaaaaaaad/namer-service/internal/status"
)

// BuildID is set by CI
var BuildID string

func setServiceHeader(h http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("X-Reply-Service", "namer-service")
		if BuildID == "" {
			w.Header().Set("X-Version", "dev")
		} else {
			w.Header().Set("X-Version", BuildID)
		}

		h.ServeHTTP(w, r)
	})
}

func main() {
	globalmux := http.NewServeMux()

	globalmux.HandleFunc("/", namer.NameHandler)
	globalmux.HandleFunc("/status/alive", status.AliveHandler)
	globalmux.HandleFunc("/status/ready", status.ReadyHandler)

	log.Fatal(http.ListenAndServe(":5003", setServiceHeader(globalmux)))
}
