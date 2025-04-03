# Emoji Reaction App - Flutter Frontend

This is the Flutter web frontend for the "Full Stack Development with Dart" presentation.

## Overview

This frontend connects to either a basic Shelf backend or a Serverpod-style backend to display real-time emoji reactions.

## Running the Frontend

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run the app with the standard backend:
   ```bash
   flutter run -d chrome
   ```

3. Run the app with the Serverpod-style backend:
   ```bash
   flutter run -d chrome -t lib/main_serverpod.dart
   ```

## Implementation Details

The frontend has two main views:
- Presenter view: Shows emoji counters and animations
- Audience view: Provides buttons to send emoji reactions

## Connecting to Different Backends

The app can connect to two different backend implementations:

1. **Standard Shelf Backend**:
   - Uses `WebSocketService`
   - Simple message format
   - Run with `flutter run -d chrome`

2. **Serverpod-Style Backend**:
   - Uses `ServerpodWebSocketService`
   - Structured message format with channels and endpoints
   - Run with `flutter run -d chrome -t lib/main_serverpod.dart`

## Key Features

- Real-time WebSocket communication
- Animated emoji reactions
- QR code for audience access
- Connection status indicator
- Automatic reconnection
