import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';

import 'package:emoji_reaction_backend/websocket_handler.dart';
import 'package:emoji_reaction_backend/middleware/cors.dart';
import 'package:emoji_reaction_backend/middleware/logging.dart' as custom_logging;

void main() async {
  // Create router
  final router = Router();
  
  // Add WebSocket handler
  final webSocketHandler = WebSocketHandler();
  router.get('/ws', webSocketHandler.handler);
  
  // Create a directory for static files if it doesn't exist
  final publicDir = Directory('public');
  if (!publicDir.existsSync()) {
    publicDir.createSync();
    
    // Create a simple index.html file
    final indexFile = File('public/index.html');
    indexFile.writeAsStringSync('''
    <!DOCTYPE html>
    <html>
    <head>
      <title>Emoji Reaction App</title>
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 20px; }
        h1 { color: #333; }
      </style>
    </head>
    <body>
      <h1>Emoji Reaction App</h1>
      <p>This is a placeholder page. The Flutter web app will be served here when deployed.</p>
      <p>WebSocket endpoint is available at: <code>ws://localhost:8080/ws</code></p>
    </body>
    </html>
    ''');
  }
  
  // Add static file handler for the frontend
  final staticHandler = createStaticHandler('public', 
      defaultDocument: 'index.html');
  
  router.get('/<ignored|.*>', (Request request) {
    return staticHandler(request);
  });
  
  // Create a handler pipeline
  final handler = Pipeline()
      .addMiddleware(custom_logging.logRequests())
      .addMiddleware(corsMiddleware())
      .addHandler(router);

  // Serve the application
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, InternetAddress.anyIPv4, port);
  
  print('Server listening on port ${server.port}');
  print('WebSocket endpoint available at ws://localhost:${server.port}/ws');
  print('View the app at http://localhost:${server.port}');
}
