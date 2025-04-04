# Full Stack Dart - Emoji Reaction App

A real-time emoji reaction application built entirely with Dart, using Flutter for the frontend and Dart for the backend.

## Project Structure

```
full-stack-dart/
├── backend/             # Dart server using shelf
│   ├── bin/             # Server entry point
│   └── lib/             # Server logic
├── frontend/            # Flutter web application
│   └── lib/             # Flutter app code
└── shared/              # Shared models between frontend and backend
    └── models/          # Data models
```

## Features

- Real-time emoji reactions using WebSockets
- Presenter view with reaction counts and animations
- Audience view for sending reactions
- QR code for easy audience participation
- Responsive design for various screen sizes

## Backend

The backend is built with Dart using the shelf package for HTTP server functionality and WebSockets for real-time communication. It:

- Manages WebSocket connections
- Tracks emoji reaction counts
- Broadcasts reactions to all connected clients
- Serves static files for the frontend

## Frontend

The frontend is built with Flutter for web and includes:

- Home screen with navigation options
- Presenter view showing reaction counts and animations
- Audience view for sending reactions
- Connection status indicator
- Automatic reconnection logic

## Getting Started

### Prerequisites

- Dart SDK 3.0.0 or higher
- Flutter SDK 3.0.0 or higher

### Running the Backend

```bash
cd backend
dart pub get
dart run bin/server.dart
```

The server will start on port 8080 by default.

### Running the Frontend

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

For development, the frontend will connect to the backend at `ws://localhost:8080/ws`.

## Deployment

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

## License

This project is open source and available under the MIT License.
