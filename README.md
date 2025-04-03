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
├── presentation/           # Presentation materials
│   ├── presentation.md     # Comprehensive presentation content
│   └── assets/             # Images and diagrams for presentation
└── .gitignore              # Root gitignore file
```

Each subdirectory has its own `.gitignore` file with appropriate rules for that project type.

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

## Git Management

This repository uses `.gitignore` files in each directory to prevent committing unnecessary files. If you've accidentally committed files that should be ignored:

1. Use the provided cleanup script:
   ```bash
   ./git_cleanup.sh
   ```

2. For removing files from git history (use with caution):
   ```bash
   ./remove_from_git_history.sh
   ```

Note: Removing files from git history will rewrite commits and require a force push.