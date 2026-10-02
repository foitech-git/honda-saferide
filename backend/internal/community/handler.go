package community

import (
	"encoding/json"
	"net/http"
)

type ReportRequest struct {
	Type        string  `json:"type"` // e.g., Pothole, Accident
	Latitude    float64 `json:"latitude"`
	Longitude   float64 `json:"longitude"`
	Description string  `json:"description,omitempty"`
}

type ReportResponse struct {
	Status   string `json:"status"`
	ReportID string `json:"report_id"`
}

func CreateReportHandler(w http.ResponseWriter, r *http.Request) {
	var req ReportRequest
	if err := json.NewDecoder(r.Body).Decode(&req); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// Mock Community Report creation
	// Future: Insert Point(Longitude, Latitude) into PostGIS `community_reports`
	resp := ReportResponse{
		Status:   "REPORT_SUBMITTED",
		ReportID: "rep_comm_123",
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	json.NewEncoder(w).Encode(resp)
}
