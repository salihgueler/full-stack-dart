# Full Stack Development with Dart

This repository contains the demo application for the "Full Stack Development with Dart" presentation.

## Project Overview

This is a real-time emoji reaction counter application built entirely with Dart:
- Backend: Dart Shelf (WebSocket Server)
- Frontend: Flutter Web
- Deployment: AWS App Runner

## Application Features

- Presenter view showing real-time emoji reactions
- Audience view with emoji reaction buttons
- Animated emoji effects (falling from top of screen)
- Real-time statistics and counters
- QR code for easy audience access

## Project Structure

```
full-stack-dart/
├── backend/                # Basic Shelf WebSocket server
│   ├── bin/                # Entry point
│   ├── lib/                # WebSocket handlers and business logic
│   └── test/               # Backend tests
├── serverpod_backend/      # Structured Shelf implementation
│   └── lib/                # Server implementation with channel-based approach
├── frontend/               # Flutter web frontend
│   ├── lib/                # Application code
│   │   ├── models/         # Data models
│   │   ├── screens/        # Presenter and audience views
│   │   ├── services/       # WebSocket services
│   │   └── widgets/        # Reusable widgets and animations
│   └── test/               # Frontend tests
├── shared/                 # Shared models and utilities
└── deployment/             # AWS deployment configuration
    ├── Dockerfile          # Container definition
    └── apprunner.yaml      # AWS App Runner configuration
```

## Development Setup

1. Install Dart SDK and Flutter
2. Clone this repository
3. Set up the backend (choose one):

   Basic Shelf implementation:
   ```bash
   cd backend
   dart pub get
   dart run bin/server.dart
   ```

   Structured implementation:
   ```bash
   cd serverpod_backend
   dart pub get
   dart run lib/server.dart
   ```

4. Set up the frontend (choose matching implementation):

   For basic Shelf backend:
   ```bash
   cd frontend
   flutter pub get
   flutter run -d chrome
   ```

   For structured backend:
   ```bash
   cd frontend
   flutter pub get
   flutter run -d chrome -t lib/main_serverpod.dart
   ```

## AWS Deployment Steps

1. Build and push Docker image
2. Create AWS App Runner service
3. Configure environment variables
4. Deploy the application

## Presentation Flow

1. Introduction to full-stack Dart development
2. Architecture overview of the emoji reaction app
3. Building the WebSocket server with Dart Shelf
4. Implementing a more structured backend approach
5. Implementing real-time communication
6. Adding animations for emoji reactions
7. Deploying to AWS
8. Live demo with audience participation
9. Common considerations as a full-stack developer
