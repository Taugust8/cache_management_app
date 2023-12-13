# Flutter Cache Management Demo 😎

## Introduction
This Flutter project showcases efficient cache management techniques using Hive and Cached Network Image. It demonstrates handling API calls, caching responses, and managing image loading and caching.

This demo was developed as part of a presentation at a flutter meetup in Montreal for the Google Developer Group 🇨🇦🍁

## Features
- API data fetching and handling.
- Advanced caching of API responses using Hive.
- Image caching with Cached Network Image.
- Demonstration of cache management in gallery and weather screens.

## Cache Mechanism and Expiration Strategy

### Cache Mechanism
- **CacheEntry:** Represents cached items with data and an expiration time. Includes a method to check if the cache is expired.
- **CacheEntryAdapter:** Handles serialization and deserialization of CacheEntry objects for Hive.
- **CacheManager:** Central manager for caching operations. It initializes Hive, manages Hive boxes for storing cached data, and handles storage, retrieval, and validity checks of cache entries.
- **DataManager Classes:** Manage feature-specific data (gallery and weather), interfacing with ApiClient for data fetching and CacheManager for caching.

### Expiration Strategy
Cached data's validity is controlled by an expiration time.
System checks if cached data exists and is valid; if not, it fetches fresh data from the API and updates the cache with a new expiration time.
expirationDurationInSeconds in data managers specifies the duration for which cached data remains valid.

## Getting Started
To run this project:
1. Clone the repository.
2. Navigate to the project directory.
3. Run `flutter pub get` to install dependencies.
4. Launch the app with `flutter run`.

## Project Structure
- **api/:** API integration and data fetching logic.
- **cache/:** Caching mechanisms using Hive.
- **data/:** Data management for different features.
- **screens/:** UI components for gallery and weather displays.
- **main.dart:** Main entry point of the application.

## Dependencies
- Hive
- Cached Network Image
