package sos

import (
	"encoding/json"
	"net/http"
)

type SOSRequest struct {
	VehicleID string  `json:"vehicle_id"`
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
}

type SOSResponse struct {
	Status  string `json:"status"`
	Message string `json:"message"`
	EventID string `json:"event_id"`
}

func ActivateHandler(w http.ResponseWriter, r *http.Request) {
	var req SOSRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// Mock SOS activation
	// Future: Write geometry to PostGIS and push real-time event to Redis/WebSockets
	resp := SOSResponse{
		Status:  "SOS_ACTIVE",
		Message: "Emergency services and contacts have been notified",
		EventID: "evt_sos_999",
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusAccepted)
	json.NewEncoder(w).Encode(resp)
}
