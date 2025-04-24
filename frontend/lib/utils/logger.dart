import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

/// A utility class for logging in the application.
class AppLogger {
  static final Map<String, Logger> _loggers = {};
  
  /// Initialize the logging system.
  /// Should be called once at app startup.
  static void init() {
    Logger.root.level = kDebugMode ? Level.ALL : Level.INFO;
    Logger.root.onRecord.listen((record) {
      // Format: [LEVEL] LOGGER_NAME: MESSAGE
      final message = '[${record.level.name}] ${record.loggerName}: ${record.message}';
      
      // Add stack trace if available
      final stackTrace = record.stackTrace != null ? '\n${record.stackTrace}' : '';
      
      // Use print for now, but this could be replaced with a more sophisticated
      // logging backend in the future
      // ignore: avoid_print
      print('$message$stackTrace');
    });
  }
  
  /// Get a logger for a specific class or component.
  /// 
  /// Example:
  /// ```dart
  /// final logger = AppLogger.getLogger('WebSocketService');
  /// logger.info('Connected to server');
  /// ```
  static Logger getLogger(String name) {
    return _loggers.putIfAbsent(name, () => Logger(name));
  }
}
