# Honda SafeRide Data Model

This document defines the database schema for the Honda SafeRide platform.
The backend utilizes **PostgreSQL** for relational data and **PostGIS** for spatial data (locations, routes, routing metrics).

## 1. Core Entities

### `users`
Represents the vehicle owners/drivers.
- `id` (UUID, Primary Key)
- `email` (VARCHAR, Unique, Indexed)
- `password_hash` (VARCHAR)
- `name` (VARCHAR)
- `created_at` (TIMESTAMP)

### `vehicles`
Represents the vehicles owned by users.
- `id` (UUID, Primary Key)
- `user_id` (UUID, Foreign Key -> `users.id`)
- `make` (VARCHAR) - e.g., Honda
- `model` (VARCHAR) - e.g., Civic, Activa
- `year` (INT)
- `type` (VARCHAR) - e.g., Car, Motorcycle, Scooter, Truck
- `health_status` (VARCHAR) - e.g., Good, Needs Attention
- `created_at` (TIMESTAMP)

### `devices`
Represents the physical IoT hardware installed in vehicles.
- `id` (UUID, Primary Key)
- `vehicle_id` (UUID, Foreign Key -> `vehicles.id`, Nullable)
- `device_serial` (VARCHAR, Unique) - e.g., HSR-DEV-000001
- `firmware_version` (VARCHAR)
- `status` (VARCHAR) - e.g., Connected, Disconnected

---

## 2. Spatial Entities (PostGIS)

### `places`
Points of interest such as Safe Parking, EV Charging, and Fuel.
- `id` (UUID, Primary Key)
- `name` (VARCHAR)
- `category` (VARCHAR) - Safe Parking, EV Charging, Fuel
- `location` (GEOMETRY(Point, 4326)) - PostGIS spatial point
- `rating` (FLOAT)
- `rating_count` (INT)

### `community_reports`
User-submitted hazards and road intelligence.
- `id` (UUID, Primary Key)
- `type` (VARCHAR) - Pothole, Accident, Road Work, Poor Lighting
- `location` (GEOMETRY(Point, 4326)) - PostGIS spatial point
- `description` (TEXT)
- `source` (VARCHAR) - Generic identifier to protect privacy
- `status` (VARCHAR) - Active, Resolved
- `created_at` (TIMESTAMP)

### `sos_events`
High-priority emergency triggers.
- `id` (UUID, Primary Key)
- `vehicle_id` (UUID, Foreign Key -> `vehicles.id`)
- `location` (GEOMETRY(Point, 4326)) - Exact coordinates at time of trigger
- `status` (VARCHAR) - Active, Cancelled, Resolved
- `created_at` (TIMESTAMP)

---

## 3. Service & History Entities

### `service_records`
Historical maintenance records.
- `id` (UUID, Primary Key)
- `vehicle_id` (UUID, Foreign Key -> `vehicles.id`)
- `title` (VARCHAR) - e.g., Periodic Service
- `date` (DATE)
- `mileage` (INT)
- `provider` (VARCHAR)
- `status` (VARCHAR)

### `parts_records`
Component tracking.
- `id` (UUID, Primary Key)
- `vehicle_id` (UUID, Foreign Key -> `vehicles.id`)
- `part_name` (VARCHAR) - e.g., Brake Pads
- `manufacturer` (VARCHAR)
- `installed_date` (DATE)
- `mileage_at_install` (INT)

---

## 4. Redis Caching Structure

- **Vehicle Telemetry**: `telemetry:veh_{id}` -> JSON (Speed, Fuel, Battery, Location)
- **Active Assist Tracking**: `assist:req_{id}` -> JSON (Provider location, ETA)
- **Session Tokens**: `session:usr_{id}` -> JWT Token Data
