# Emoji Reaction App - Serverpod-Style Backend

This is a Serverpod-style implementation of the emoji reaction backend for the "Full Stack Development with Dart" presentation.

## Overview

This backend demonstrates a Serverpod-inspired architecture using Shelf:

- WebSocket communication with structured messages
- Channel-based message routing
- Endpoint-style API calls
- Serialization of models

## Running the Server

1. Install dependencies:
   ```bash
   dart pub get
   ```

2. Start the server:
   ```bash
   dart run lib/server.dart
   ```

The server will start on port 8080 with the WebSocket endpoint available at `ws://localhost:8080/ws`.

## Implementation Details

- Structured message format similar to Serverpod
- Channel-based communication
- Endpoint-style method calls

## Connecting from Flutter

Update your WebSocket service in the Flutter app to connect to this endpoint:

```dart
// Use the ServerpodWebSocketService instead of the regular WebSocketService
final service = ServerpodWebSocketService();
service.connect();
```

## Message Format

### Client to Server
```json
{
  "type": "call",
  "endpoint": "emoji",
  "method": "addReaction",
  "params": ["👍"]
}
```

### Server to Client
```json
{
  "type": "stream",
  "channel": "emoji",
  "streamChannel": "reaction",
  "data": {
    "emoji": "👍",
    "timestamp": "2023-04-03T10:15:30Z"
  }
}
```

## Comparison with Standard Shelf

This implementation demonstrates a more structured approach compared to the basic Shelf implementation:

- Message format follows a consistent pattern
- Channel-based communication for better organization
- Endpoint-style method calls for clearer API design

While not using the actual Serverpod framework, this implementation shows how to structure a Dart backend in a similar style.
