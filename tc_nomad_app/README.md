# TC Nomad - Travel Packing Assistant

An AI-powered travel packing assistant mobile app that helps travelers pack efficiently using smart recommendations and visual packing guidance.

## Features

### Core Features (MVP)
- 🔐 **Authentication** - Email, Google, and Apple Sign-In
- ✈️ **Trip Management** - Create and manage trips with AI-powered recommendations
- 🧳 **Luggage Profiles** - Save and reuse luggage configurations
- 📦 **Smart Packing Lists** - AI-generated packing lists based on trip context
- 🎯 **Visual Packing Guide** - Interactive compartment-based packing system (unique feature)
- 🌤️ **Weather Integration** - Weather-adapted packing recommendations
- ✅ **Airline Compliance** - Check baggage rules and dimensions
- 💎 **Freemium Model** - Free tier with Pro subscription ($1.99/mo or $9.99/yr)

## Architecture

### Tech Stack
- **Framework**: Flutter 3.x
- **State Management**: Riverpod
- **Backend**: Custom REST API
- **Local Storage**: Hive + SharedPreferences
- **Navigation**: GoRouter
- **Design**: Apple-inspired liquid glass (glassmorphism)

### Project Structure
```
lib/
├── core/               # Core utilities, theme, constants
├── features/           # Feature modules (auth, trip, packing, etc.)
├── models/            # Data models
├── providers/         # Riverpod providers
├── repositories/      # Data access layer
└── services/          # API services
```

## Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### Installation
```bash
flutter pub get
flutter run
```

### Build
```bash
# iOS
flutter build ios

# Android
flutter build apk
```

## Design System

The app uses an Apple-inspired liquid glass design with:
- Glassmorphism effects
- Smooth animations
- Clean typography (SF Pro)
- Blue gradient primary color (#007AFF)

## API Integration

Currently uses mock services for:
- OpenAI API (packing list generation)
- OpenWeatherMap API (weather forecasts)
- Custom REST API (backend)

Replace mock services with real API endpoints when ready.

## License

Proprietary - All rights reserved
