import 'dart:io';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// This is a simplified version that uses Shelf but follows Serverpod-like patterns
void main() async {
  // Store all active WebSocket connections
  final connections = <WebSocketChannel>[];
  
  // Store emoji reaction counts
  final emojiCounts = {
    '👍': 0,
    '❤️': 0,
    '😂': 0,
    '😮': 0,
    '👏': 0,
    '🎉': 0,
  };

  // WebSocket handler
  final wsHandler = webSocketHandler((WebSocketChannel webSocket) {
    print('New client connected to Serverpod-style backend');
    connections.add(webSocket);
    
    // Send current emoji counts to the new client
    webSocket.sink.add(jsonEncode({
      'type': 'stream',
      'channel': 'emoji',
      'streamChannel': 'counts',
      'data': {
        'counts': emojiCounts,
      },
    }));
    
    // Listen for messages from the client
    webSocket.stream.listen(
      (message) {
        try {
          final data = jsonDecode(message);
          print('Received message: $data');
          
          // Handle endpoint calls (Serverpod-style)
          if (data['type'] == 'call' && 
              data['endpoint'] == 'emoji' && 
              data['method'] == 'addReaction') {
            
            final emoji = data['params'][0];
            if (emojiCounts.containsKey(emoji)) {
              emojiCounts[emoji] = (emojiCounts[emoji] ?? 0) + 1;
              print('Incremented count for $emoji: ${emojiCounts[emoji]}');
              
              // Broadcast the reaction to all clients
              for (final conn in connections) {
                conn.sink.add(jsonEncode({
                  'type': 'stream',
                  'channel': 'emoji',
                  'streamChannel': 'reaction',
                  'data': {
                    'emoji': emoji,
                    'timestamp': DateTime.now().toIso8601String(),
                  },
                }));
              }
              
              // Broadcast updated counts
              for (final conn in connections) {
                conn.sink.add(jsonEncode({
                  'type': 'stream',
                  'channel': 'emoji',
                  'streamChannel': 'counts',
                  'data': {
                    'counts': emojiCounts,
                  },
                }));
              }
            }
          }
        } catch (e) {
          print('Error handling message: $e');
        }
      },
      onDone: () {
        print('Client disconnected');
        connections.remove(webSocket);
      },
      onError: (error) {
        print('Error: $error');
        connections.remove(webSocket);
      },
      cancelOnError: false,
    );
  });

  // Create a handler for all requests
  final handler = const Pipeline()
      .addMiddleware((innerHandler) {
        return (request) async {
          // Add CORS headers
          if (request.method == 'OPTIONS') {
            return Response.ok('', headers: {
              'Access-Control-Allow-Origin': '*',
              'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
              'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Auth-Token, Accept',
            });
          }
          
          final response = await innerHandler(request);
          return response.change(headers: {
            ...response.headers,
            'Access-Control-Allow-Origin': '*',
          });
        };
      })
      .addHandler((request) {
        if (request.url.path == 'ws') {
          return wsHandler(request);
        }
        
        if (request.url.path.isEmpty || request.url.path == '') {
          return Response.ok(
            '''
<!DOCTYPE html>
<html>
<head>
  <title>Emoji Reaction App - Serverpod Style</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    body { 
      font-family: Arial, sans-serif; 
      text-align: center; 
      padding: 20px;
      max-width: 800px;
      margin: 0 auto;
      line-height: 1.6;
    }
    h1 { color: #333; }
    .container {
      background-color: #f5f5f5;
      border-radius: 8px;
      padding: 20px;
      margin-top: 30px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    code {
      background-color: #e0e0e0;
      padding: 2px 5px;
      border-radius: 3px;
      font-family: monospace;
    }
  </style>
</head>
<body>
  <h1>Emoji Reaction App - Serverpod Style Backend</h1>
  <p>This is a Serverpod-style implementation of the emoji reaction backend.</p>
  
  <div class="container">
    <h2>WebSocket Information</h2>
    <p>WebSocket endpoint is available at: <code>ws://localhost:8080/ws</code></p>
    <p>Connect your Flutter frontend to this endpoint to use this backend.</p>
  </div>
</body>
</html>
            ''',
            headers: {'content-type': 'text/html'},
          );
        }
        
        return Response.notFound('Not found');
      });

  // Start the server on port 8080 instead of 8090
  final server = await serve(handler, InternetAddress.anyIPv4, 8080);
  print('Server started on port 8080');
  print('WebSocket endpoint available at ws://localhost:8080/ws');
}
