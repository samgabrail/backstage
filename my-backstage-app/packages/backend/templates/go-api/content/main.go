package main

import (
	"fmt"
	"net/http"
)

// helloHandler responds with a "Hello, World!" message
func helloHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, World! This is your Go API speaking!")
}

func main() {
	// Register the helloHandler function to the root route
	http.HandleFunc("/", helloHandler)

	// Start the server on port 8080
	fmt.Println("Server starting on port 8080...")
	if err := http.ListenAndServe("0.0.0.0:8080", nil); err != nil {
		fmt.Printf("Error starting server: %s\n", err)
	}
}
