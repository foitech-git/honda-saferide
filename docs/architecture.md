# Honda SafeRide Architecture

## Overview
Honda SafeRide follows a **Clean Architecture** approach using **Flutter** and **Riverpod** for state management and dependency injection. The application is designed to be a **Modular Monolith** initially, allowing for clear separation of concerns while keeping deployment and development straightforward.

## Core Principles
- **Separation of Concerns:** UI, Business Logic, and Data access are strictly separated.
- **Dependency Inversion:** Interfaces (Repositories) belong to the Domain layer, while implementations belong to the Data layer.
- **Unidirectional Data Flow:** Data flows from Data -> Domain -> Presentation.
- **Mock-First Development:** The app is configured to run fully on mock data (`Environment.current.useMockData`) to facilitate rapid UI/UX development based on the Stitch designs without waiting for backend APIs.

## Directory Structure
- `lib/app/`: App-wide initialization, DI setup, and global configurations.
- `lib/core/`: Shared utilities, networking clients, theme, routing, and errors.
- `lib/domain/`: Enterprise logic (Entities, Repository Interfaces, Use Cases).
- `lib/data/`: Data access implementations (Models, Repository Implementations, Data Sources).
- `lib/features/`: Feature-based UI and Riverpod providers (e.g., Auth, Home, SOS).
- `lib/services/`: External services integration (e.g., Maps, MQTT).
- `lib/widgets/`: Reusable, domain-agnostic UI components.

## Tech Stack Decisions
- **State Management:** `flutter_riverpod` for scalable, compile-safe dependency injection and state management.
- **Routing:** `go_router` for declarative routing and deep linking (crucial for Web support).
- **Styling:** Material 3 with a heavily customized Dark Theme (referencing `docs/ui-reference.md`).
- **Logging:** `logging` package for structured log output.

## Backend and Future Scaling
- Backend is currently mocked. Future implementation will use Go (REST/WebSocket), PostgreSQL, PostGIS, and Redis.
- A MapService abstraction will be created to prevent tight coupling with Google Maps Platform.
- Hardware integrations (MQTT, EMQX) will be introduced in later phases.
