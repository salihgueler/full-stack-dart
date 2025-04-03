import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerpodWebSocketService extends ChangeNotifier {
  WebSocketChannel? _channel;
  bool _isConnected = false;
  String _error = '';
  
  // Emoji reaction counts
  final Map<String, int> _emojiCounts = {
    '👍': 0,
    '❤️': 0,
    '😂': 0,
    '😮': 0,
    '👏': 0,
    '🎉': 0,
  };
  
  // Recent reactions for animation
  final List<String> _recentReactions = [];
  
  // Getters
  bool get isConnected => _isConnected;
  String get error => _error;
  Map<String, int> get emojiCounts => Map.unmodifiable(_emojiCounts);
  List<String> get recentReactions => List.unmodifiable(_recentReactions);
  
  // Get the appropriate WebSocket URL for Serverpod-style backend
  String getWebSocketUrl() {
    // For web, determine the WebSocket URL based on the current page URL
    if (kIsWeb) {
      final location = Uri.base;
      final wsProtocol = location.scheme == 'https' ? 'wss' : 'ws';
      
      // When running in Flutter dev mode with backend on port 8080
      if (location.toString().contains('localhost')) {
        return 'ws://localhost:8080/ws';
      }
      
      // For deployed environments, use the same host
      return '$wsProtocol://${location.host}/ws';
    }
    
    // For non-web platforms, default to localhost
    return 'ws://localhost:8080/ws';
  }
  
  // Connect to WebSocket server
  void connect([String? url]) {
    try {
      final wsUrl = url ?? getWebSocketUrl();
      print('Connecting to Serverpod-style WebSocket at: $wsUrl');
      
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      
      // Send initial subscription message for Serverpod-style channels
      _channel!.sink.add(jsonEncode({
        'type': 'subscribe',
        'channel': 'emoji',
      }));
      
      // Listen for messages
      _channel!.stream.listen(
        _onMessage,
        onDone: _onDisconnect,
        onError: _onError,
        cancelOnError: false,
      );
      
      _isConnected = true;
      _error = '';
      notifyListeners();
    } catch (e) {
      _error = 'Failed to connect: $e';
      _isConnected = false;
      print('WebSocket connection error: $e');
      notifyListeners();
    }
  }
  
  // Disconnect from WebSocket server
  void disconnect() {
    _channel?.sink.close();
    _isConnected = false;
    notifyListeners();
  }
  
  // Send an emoji reaction
  void sendReaction(String emoji) {
    if (!_isConnected || _channel == null) {
      print('Cannot send reaction: not connected');
      return;
    }
    
    try {
      // Format for Serverpod-style endpoint call
      final message = jsonEncode({
        'type': 'call',
        'endpoint': 'emoji',
        'method': 'addReaction',
        'params': [emoji],
      });
      
      print('Sending reaction to Serverpod-style backend: $emoji');
      _channel!.sink.add(message);
      
      // Add to local reactions immediately for better UX
      _recentReactions.add(emoji);
      notifyListeners();
    } catch (e) {
      print('Error sending reaction: $e');
    }
  }
  
  // Handle incoming WebSocket messages
  void _onMessage(dynamic message) {
    print('Received message from Serverpod-style backend: $message');
    
    try {
      final data = jsonDecode(message);
      
      // Handle Serverpod-style channel messages
      if (data['type'] == 'stream' && data['channel'] == 'emoji') {
        final streamData = data['data'];
        final streamChannel = data['streamChannel'];
        
        if (streamChannel == 'counts') {
          // Update emoji counts
          final counts = streamData['counts'] as Map<String, dynamic>;
          counts.forEach((emoji, count) {
            _emojiCounts[emoji] = count as int;
          });
          print('Updated emoji counts: $_emojiCounts');
          notifyListeners();
        } else if (streamChannel == 'reaction') {
          // Add to recent reactions for animation
          final emoji = streamData['emoji'] as String;
          _recentReactions.add(emoji);
          print('Added reaction: $emoji');
          
          // Limit the number of recent reactions to prevent memory issues
          // Increased to 200 to allow more animations on screen at once
          if (_recentReactions.length > 200) {
            _recentReactions.removeAt(0);
          }
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error parsing message: $e');
    }
  }
  
  // Handle WebSocket disconnection
  void _onDisconnect() {
    print('WebSocket disconnected');
    _isConnected = false;
    _error = 'Disconnected from server';
    notifyListeners();
    
    // Try to reconnect after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (!_isConnected) {
        print('Attempting to reconnect...');
        connect();
      }
    });
  }
  
  // Handle WebSocket errors
  void _onError(error) {
    print('WebSocket error: $error');
    _isConnected = false;
    _error = 'WebSocket error: $error';
    notifyListeners();
  }
  
  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
