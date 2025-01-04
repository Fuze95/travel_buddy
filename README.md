# TravelBuddy 🌍✈️

A comprehensive Flutter travel app for exploring Sri Lanka, featuring offline capabilities, trip planning, and interactive destination guides.

## Features 🌟

### Core Functionality
- **Destination Discovery**: Browse and search through curated destinations across Sri Lanka
- **Trip Planning**: Create and manage travel itineraries
- **Interactive Maps**: Explore destinations with map
- **Travel Guides**: Access comprehensive guides for each destination
- **Favorites System**: Save and manage favorite destinations
- **Offline Support**: Access key features without internet connectivity

### Key Screens
1. **Home/Explore Screen**
   - Categorized destination browsing
   - Popular destinations showcase
   - Quick search functionality

2. **Destination Details Screen**
   - Comprehensive destination information
   - Activities and highlights
   - Weather information
   - Transportation options
   - Local tips
   - Map integration

3. **Trip Planning Screen**
   - Create new trip plans
   - Manage existing itineraries
   - Add multiple destinations
   - Trip description and notes

4. **Maps Screen**
   - Interactive destination map
   - Location markers
   - Quick destination preview
   - Navigation support

5. **Favorites Screen**
   - Saved destinations
   - Quick access to favorite places
   - Easy management

6. **Travel Guides Screen**
   - Detailed travel information
   - FAQs about Sri Lanka
   - Travel tips and recommendations

## Technical Implementation 🔧

### Architecture
- **State Management**: Provider pattern for app-wide state management
- **Database**: Firebase Firestore for destination data
- **Local Storage**: SharedPreferences for user settings and offline data
- **Navigation**: Material page routing with custom transitions

### Key Components
- Custom widgets for consistent UI elements
- Reusable components for destination cards and list items
- Custom navigation implementation
- Theme management system
- Offline data synchronization

### Dependencies
- `provider`: State management
- `cloud_firestore`: Backend database
- `shared_preferences`: Local storage
- `cached_network_image`: Image caching
- `flutter_map`: Map integration
- `flutter_svg`: SVG asset support

## Project Structure 📁

```
lib/
├── models/
│   └── destination.dart
├── screens/
│   ├── home_screen.dart
│   ├── destination_details_screen.dart
│   ├── trip_planning_screen.dart
│   ├── map_screen.dart
│   ├── favorites_screen.dart
│   └── ...
├── services/
│   ├── destination_provider.dart
│   ├── favorites_provider.dart
│   ├── firebase_service.dart
│   └── user_provider.dart
├── widgets/
│   ├── custom_app_bar.dart
│   ├── destination_card.dart
│   ├── custom_bottom_nav_bar.dart
│   └── ...
└── main.dart
```

## Acknowledgments 👏

- Design inspiration from various travel apps
- Flutter and Firebase documentation
