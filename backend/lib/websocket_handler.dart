import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketHandler {
  // Store all active WebSocket connections
  final _connections = <WebSocketChannel>[];
  
  // Store emoji reaction counts
  final Map<String, int> _emojiCounts = {
    '👍': 0,
    '❤️': 0,
    '😂': 0,
    '😮': 0,
    '👏': 0,
    '🎉': 0,
  };

  // Create the WebSocket handler
  Handler get handler => webSocketHandler(_onWebSocketConnect);

  // Handle new WebSocket connections
  void _onWebSocketConnect(WebSocketChannel webSocket) {
    print('New client connected');
    _connections.add(webSocket);
    
    // Send current emoji counts to the new client
    _sendEmojiCounts(webSocket);
    
    // Listen for messages from the client
    webSocket.stream.listen(
      (message) {
        _handleMessage(webSocket, message);
      },
      onDone: () {
        print('Client disconnected');
        _connections.remove(webSocket);
      },
      onError: (error) {
        print('Error: $error');
        _connections.remove(webSocket);
      },
      cancelOnError: false,
    );
  }

  // Handle incoming messages
  void _handleMessage(WebSocketChannel webSocket, dynamic message) {
    try {
      print('Received message: $message');
      final data = jsonDecode(message);
      
      if (data['type'] == 'reaction') {
        final emoji = data['emoji'] as String;
        if (_emojiCounts.containsKey(emoji)) {
          _emojiCounts[emoji] = (_emojiCounts[emoji] ?? 0) + 1;
          print('Incremented count for $emoji: ${_emojiCounts[emoji]}');
          
          // Broadcast the reaction to all clients
          _broadcastReaction(emoji);
          
          // Broadcast updated counts
          _broadcastEmojiCounts();
        }
      }
    } catch (e) {
      print('Error handling message: $e');
    }
  }

  // Send current emoji counts to a specific client
  void _sendEmojiCounts(WebSocketChannel webSocket) {
    final message = jsonEncode({
      'type': 'counts',
      'counts': _emojiCounts,
    });
    
    try {
      webSocket.sink.add(message);
      print('Sent counts to new client: $message');
    } catch (e) {
      print('Error sending counts: $e');
    }
  }

  // Broadcast emoji counts to all connected clients
  void _broadcastEmojiCounts() {
    final message = jsonEncode({
      'type': 'counts',
      'counts': _emojiCounts,
    });
    
    print('Broadcasting counts: $message');
    
    for (final connection in _connections) {
      try {
        connection.sink.add(message);
      } catch (e) {
        print('Error broadcasting counts: $e');
      }
    }
  }

  // Broadcast a reaction to all connected clients
  void _broadcastReaction(String emoji) {
    final message = jsonEncode({
      'type': 'reaction',
      'emoji': emoji,
    });
    
    print('Broadcasting reaction: $emoji');
    
    for (final connection in _connections) {
      try {
        connection.sink.add(message);
      } catch (e) {
        print('Error broadcasting reaction: $e');
      }
    }
  }
}
