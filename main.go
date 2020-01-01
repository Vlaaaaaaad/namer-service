package main

import (
	"log"
	"net/http"
)

func main() {
	globalmux := http.NewServeMux()

	globalmux.HandleFunc("/", namerHandler)
	globalmux.HandleFunc("/status/alive", aliveHandler)
	globalmux.HandleFunc("/status/ready", readyHandler)

	log.Fatal(http.ListenAndServe(":5003", globalmux))
}
