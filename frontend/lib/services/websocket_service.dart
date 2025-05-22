import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../utils/logger.dart';

class WebSocketService extends ChangeNotifier {
  final Logger _logger = AppLogger.getLogger('WebSocketService');
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

  // Get the appropriate WebSocket URL based on current environment
  String getWebSocketUrl() {
    // Check for environment variable using dotenv
    final envUrl = dotenv.env['WEB_SOCKET_LINK'];
    if (envUrl != null && envUrl.isNotEmpty) {
      _logger.info('Using WebSocket URL from environment: $envUrl');
      return envUrl;
    }
    
    // For web, determine the WebSocket URL based on the current page URL
    if (kIsWeb) {
      final location = Uri.base;
      final wsProtocol = location.scheme == 'https' ? 'wss' : 'ws';
      
      if (location.toString().contains('localhost')) {
        return 'ws://localhost:8080/ws';
      }
      
      return '$wsProtocol://${location.host}/ws';
    }
    
    // For non-web platforms, check system environment variables
    if (!kIsWeb && Platform.environment.containsKey('WEB_SOCKET_LINK')) {
      return Platform.environment['WEB_SOCKET_LINK']!;
    }
    
    // Default for non-web platforms
    return 'ws://localhost:8080/ws';
  }

  // Connect to WebSocket server
  void connect([String? url]) {
    try {
      final wsUrl = url ?? getWebSocketUrl();
      _logger.info('Connecting to WebSocket at: $wsUrl');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

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
      _logger.severe('WebSocket connection error: $e');
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
      _logger.warning('Cannot send reaction: not connected');
      return;
    }

    try {
      final message = jsonEncode({
        'type': 'reaction',
        'emoji': emoji,
      });

      _logger.info('Sending reaction: $emoji');
      _channel!.sink.add(message);

      // Add to local reactions immediately for better UX
      _recentReactions.add(emoji);
      notifyListeners();
    } catch (e) {
      _logger.severe('Error sending reaction: $e');
    }
  }

  // Handle incoming WebSocket messages
  void _onMessage(dynamic message) {
    _logger.fine('Received message: $message');

    try {
      final data = jsonDecode(message);

      if (data['type'] == 'counts') {
        // Update emoji counts
        final counts = data['counts'] as Map<String, dynamic>;
        counts.forEach((emoji, count) {
          _emojiCounts[emoji] = count as int;
        });
        _logger.info('Updated emoji counts: $_emojiCounts');
        notifyListeners();
      } else if (data['type'] == 'reaction') {
        // Add to recent reactions for animation
        final emoji = data['emoji'] as String;
        _recentReactions.add(emoji);
        _logger.fine('Added reaction: $emoji');

        // Limit the number of recent reactions to prevent memory issues
        // Increased to 200 to allow more animations on screen at once
        if (_recentReactions.length > 200) {
          _recentReactions.removeAt(0);
        }
        notifyListeners();
      }
    } catch (e) {
      _logger.warning('Error parsing message: $e');
    }
  }

  // Handle WebSocket disconnection
  void _onDisconnect() {
    _logger.info('WebSocket disconnected');
    _isConnected = false;
    _error = 'Disconnected from server';
    notifyListeners();

    // Try to reconnect after a delay
    Future.delayed(const Duration(seconds: 3), () {
      if (!_isConnected) {
        _logger.info('Attempting to reconnect...');
        connect();
      }
    });
  }

  // Handle WebSocket errors
  void _onError(error) {
    _logger.severe('WebSocket error: $error');
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
