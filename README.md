# Full Stack Dart - Emoji Reaction App

A real-time emoji reaction application built entirely with Dart, using Flutter for the frontend and Dart for the backend.

## Project Structure

```
full-stack-dart/
├── backend/                         # Dart server using shelf
│   ├── bin/                         # Server entry point
│   └── lib/                         # Server logic
├── frontend/                        # Flutter web application
│   └── lib/                         # Flutter app code
├── serverpod_emoji_counter/         # Serverpod implementation
│   ├── serverpod_emoji_counter_server/    # Serverpod backend
│   ├── serverpod_emoji_counter_client/    # Generated client code
│   └── serverpod_emoji_counter_flutter/   # Flutter frontend
└── shared/                          # Shared models between frontend and backend
    └── models/                      # Data models
```

## Features

- Real-time emoji reactions using WebSockets
- Presenter view with reaction counts and animations
- Audience view for sending reactions
- QR code for easy audience participation
- Responsive design for various screen sizes

## Implementation Options

This project provides two different implementations of the same application:

1. **Shelf Implementation** (backend + frontend folders): Uses the Dart shelf package for a lightweight WebSocket server
2. **Serverpod Implementation** (serverpod_emoji_counter folder): Uses Serverpod 2.4.0 for a more structured approach

## Shelf Implementation

### Backend

The backend is built with Dart using the shelf package for HTTP server functionality and WebSockets for real-time communication. It:

- Manages WebSocket connections
- Tracks emoji reaction counts
- Broadcasts reactions to all connected clients
- Serves static files for the frontend

### Frontend

The frontend is built with Flutter for web and includes:

- Home screen with navigation options
- Presenter view showing reaction counts and animations
- Audience view for sending reactions
- Connection status indicator
- Automatic reconnection logic

### Running the Shelf Implementation

#### Prerequisites

- Dart SDK 3.0.0 or higher
- Flutter SDK 3.0.0 or higher

#### Running the Backend

```bash
cd backend
dart pub get
dart run bin/server.dart
```

The server will start on port 8080 by default.

#### Running the Frontend

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

For development, the frontend will connect to the backend at `ws://localhost:8080/ws`.

## Serverpod Implementation

The Serverpod implementation provides the same functionality but uses Serverpod 2.4.0, which offers:

- Automatic code generation for client-server communication
- Type-safe streaming methods
- Built-in connection management
- More structured approach to real-time applications

### Running the Serverpod Implementation

#### Prerequisites

- Dart SDK 3.3.0 or higher
- Flutter SDK 3.19.0 or higher
- Serverpod 2.4.0

#### Running the Server

```bash
cd serverpod_emoji_counter/serverpod_emoji_counter_server
dart pub get
dart run bin/main.dart
```

#### Running the Flutter App

```bash
cd serverpod_emoji_counter/serverpod_emoji_counter_flutter
flutter pub get
flutter run -d chrome
```

## Deployment

### Shelf Implementation

For production deployment:

1. Build the Flutter web app:
```bash
cd frontend
flutter build web
```

2. Copy the built files to the backend's public directory:
```bash
cp -r frontend/build/web/* backend/public/
```

3. Deploy the backend to your server of choice.

### Serverpod Implementation

Serverpod provides Docker configurations for easy deployment:

1. Build the Flutter web app:
```bash
cd serverpod_emoji_counter/serverpod_emoji_counter_flutter
flutter build web
```

2. Copy the built files to the server's public directory:
```bash
cp -r serverpod_emoji_counter/serverpod_emoji_counter_flutter/build/web/* serverpod_emoji_counter/serverpod_emoji_counter_server/public/
```

3. Use the provided Docker configurations to deploy the server.

## Key Differences Between Implementations

1. **Code Structure**:
   - Shelf: Manual WebSocket handling and custom serialization
   - Serverpod: Generated code and built-in streaming methods

2. **Real-time Communication**:
   - Shelf: Direct WebSocket management
   - Serverpod: Streaming methods with automatic connection handling

3. **Type Safety**:
   - Shelf: Manual serialization and deserialization
   - Serverpod: Automatic code generation ensures type safety

## License

This project is open source and available under the MIT License.
