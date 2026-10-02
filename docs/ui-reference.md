# Honda SafeRide UI/UX Reference

This document serves as the primary UI/UX source of truth for the Honda SafeRide project, derived from the original Stitch design files.

## 1. Screens Found
The following Stitch design folders/screens were identified:

**Authentication & Onboarding**
- Authentication Onboarding
- OTP Device ID Registration
- Universal Vehicle Association

**Home & Hubs**
- Home Adaptive Vehicle Hub
- Home Universal Vehicle Hub

**Journey & Navigation**
- Journey Smart Route Hazard Advisory
- Journey Universal Route Active Navigation

**Vehicle Health & Maintenance**
- Vehicle Dynamic Health Telemetry
- Service Maintenance Hub
- Roadside Repair Assistance

**Safety & Emergency**
- Safety Incident Shield SOS
- Community Hazard Mesh

**Places & Security**
- Trusted Places Perimeter Geofence Watch
- Trusted Places Verified Mobility Community Intelligence
- Place Detail Community Inspection
- Profile Device Security

**Insights & Analytics**
- Ride Insights Analytics

## 2. Major Navigation Flows
The app uses a fixed bottom navigation bar with 5 primary tabs:
1. **Home** (`home` icon): Adaptive Vehicle Hub, Quick Actions, Live Safety Feed.
2. **Journey** (`explore` icon): Smart Route, Hazard Advisory, Active Navigation.
3. **Safety** (`verified_user` icon): Safety Incident Shield SOS, Guardian Share, Security Guard.
4. **Vehicle** (`two_wheeler` icon): Dynamic Health Telemetry, Service Maintenance.
5. **Places** (`location_on` icon): Trusted Places, Perimeter Geofence Watch, Community Inspection.

## 3. Reusable UI Patterns
- **Header Bar**: Fixed top header with a translucent background (`backdrop-blur-xl`), showing the Honda SafeRide logo, current screen title, active vehicle selector (e.g., CB350 RS), notifications bell with badge, and driver profile avatar.
- **Cards & Modules**: Crisp white (`#FFFFFF`) surface resting on a `#F8FAFC` background. Uses `rounded-2xl` (1rem to 1.5rem) corners, subtle borders (`1px solid #E2E8F0`), and internal padding of `1.5rem`.
- **Telemetry Chips & Pill Badges**: Fully curved pill shapes (`rounded-full`) for connectivity tags, tire pressures, battery readouts, etc. Status-based colors: Connected (Green), Telemetry (Blue), Caution (Amber).
- **Vehicle Selector Strip**: Horizontal scrolling list of chips to switch between active vehicles.
- **Toggle Switches**: Custom track/thumb switches that change color based on state (e.g., `#16A34A` for nominal, `#E60012` for critical).

## 4. Color System
The palette is designed for high-luminance, high-contrast optimal readability.
- **Primary Red (`#E60012`)**: Brand velocity accent, primary action triggers.
- **Deep Red (`#B8000E`)**: Pressed states, active toggles.
- **Informational Blue (`#2563EB`)**: Telematics sync, GPS routing.
- **Success Green (`#16A34A`)**: Optimal health, sensors active.
- **Warning Amber (`#F59E0B`)**: Scheduled maintenance, caution alerts.
- **Emergency / Critical (`#DC2626`)**: Collision alerts, SOS beacon.
- **Text & Neutral (`#17202A`)**: Deep graphite for text legibility.
- **Canvas / Background (`#F8FAFC`)**: Base background.
- **Surface (`#FFFFFF`)**: Component containers.

## 5. Typography
- **Font Family**: Plus Jakarta Sans
- **Metric Readouts**: Uses Tabular Figures & Numeric Hierarchy (e.g., `metric-display` 40px bold paired with `metric-unit` 14px medium).
- **Micro-Copy**: `label-sm` (11px, bold) for telemetry pills and tags, maintaining high legibility.
- **Headings**: `display-lg` to `title-md` for distinct conceptual clustering.

## 6. Important Interaction Patterns
- **Hold-to-Trigger Emergency SOS**: The SOS button requires a 3-second hold to activate. Uses a radial progress fill, scaling animation, and haptic feedback (vibration) to prevent accidental triggers while wearing gloves.
- **Tactile Feedback**: Buttons and cards use dynamic micro-compression (`active:scale-95` or `scale-98`) upon press to simulate physical controls.
- **Active State Switching**: Horizontal chip lists (like Vehicle Selector) dynamically update styling (background/text colors) and add an "Active" badge when selected.
- **Simulated Scans / Async Actions**: Buttons like "Pre-Ride Safety Check" transition to a loading state with a spinner, and then to a success state before reverting.
