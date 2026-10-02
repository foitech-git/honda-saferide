# Honda SafeRide API Contract

This document outlines the REST API and WebSocket interfaces for the Honda SafeRide Go backend. 
The backend follows a Modular Monolith architecture.

## Base URL
`/api/v1`

---

## REST Endpoints

### 1. System Health
Checks the status of the API, Database, and Cache.
**Endpoint:** `GET /health`
**Response:** `200 OK`
```json
{
  "status": "ok",
  "service": "Honda SafeRide API"
}
```

### 2. Authentication
Authenticates a user and returns a JWT token.
**Endpoint:** `POST /auth/login`
**Request:**
```json
{
  "email": "user@example.com",
  "password": "securepassword"
}
```
**Response:** `200 OK`
```json
{
  "token": "mock-jwt-token-saferide",
  "user_id": "usr_mock_12345"
}
```

### 3. SOS Activation
Triggers a high-priority SOS emergency event for a vehicle.
**Endpoint:** `POST /sos/activate`
**Request:**
```json
{
  "vehicle_id": "veh_67890",
  "latitude": 37.7749,
  "longitude": -122.4194
}
```
**Response:** `202 Accepted`
```json
{
  "status": "SOS_ACTIVE",
  "message": "Emergency services and contacts have been notified",
  "event_id": "evt_sos_999"
}
```

### 4. Community Reports
Submits a road or safety hazard report.
**Endpoint:** `POST /community/reports`
**Request:**
```json
{
  "type": "Pothole",
  "latitude": 37.7750,
  "longitude": -122.4190,
  "description": "Large pothole on the right lane."
}
```
**Response:** `201 Created`
```json
{
  "status": "REPORT_SUBMITTED",
  "report_id": "rep_comm_123"
}
```

---

## WebSocket Interface

### 1. Real-time Telemetry & Events
Provides real-time, bi-directional communication for vehicle telemetry, assistance provider tracking, and SOS updates.

**Endpoint:** `GET /ws`
**Protocol:** `ws://` or `wss://`

**Example Incoming Message (Client -> Server):**
```json
{
  "action": "TELEMETRY_UPDATE",
  "device_id": "HSR-DEV-000001",
  "payload": {
    "speed": 65,
    "fuel_level": 0.85
  }
}
```

**Example Outgoing Message (Server -> Client):**
```json
{
  "event": "ASSIST_PROVIDER_UPDATE",
  "payload": {
    "status": "Provider En Route",
    "eta_minutes": 12,
    "provider_latitude": 37.7800,
    "provider_longitude": -122.4200
  }
}
```
