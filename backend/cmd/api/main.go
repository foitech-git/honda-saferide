package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"

	"saferide-backend/internal/auth"
	"saferide-backend/internal/community"
	"saferide-backend/internal/config"
	"saferide-backend/internal/realtime"
	"saferide-backend/internal/sos"
)

func main() {
	cfg := config.Load()

	// Initialize WebSockets Hub
	hub := realtime.NewHub()

	// Initialize Router
	r := chi.NewRouter()

	// Middleware
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(middleware.SetHeader("Content-Type", "application/json"))

	// Health check endpoint
	r.Get("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte(`{"status":"ok", "service":"Honda SafeRide API"}`))
	})

	// WebSocket endpoint for real-time telemetry and assist tracking
	r.Get("/ws", hub.HandleConnection)

	// API V1 Routes (Modular Monolith)
	r.Route("/api/v1", func(r chi.Router) {
		// Auth Module
		r.Post("/auth/login", auth.LoginHandler)

		// SOS Module
		r.Post("/sos/activate", sos.ActivateHandler)

		// Community Module
		r.Post("/community/reports", community.CreateReportHandler)
	})

	// Start Server
	fmt.Printf("Starting Honda SafeRide backend on port %s...\n", cfg.Port)
	if err := http.ListenAndServe(":"+cfg.Port, r); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
