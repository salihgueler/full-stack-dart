import 'package:logging/logging.dart';

/// A utility class for logging in the backend application.
class AppLogger {
  static final Map<String, Logger> _loggers = {};
  
  /// Initialize the logging system.
  /// Should be called once at server startup.
  static void init() {
    // Set default level to INFO, can be overridden with environment variables
    Logger.root.level = Level.INFO;
    
    Logger.root.onRecord.listen((record) {
      // Format: TIMESTAMP [LEVEL] LOGGER_NAME: MESSAGE
      final timestamp = record.time.toIso8601String();
      final message = '$timestamp [${record.level.name}] ${record.loggerName}: ${record.message}';
      
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
  /// final logger = AppLogger.getLogger('WebSocketHandler');
  /// logger.info('Client connected');
  /// ```
  static Logger getLogger(String name) {
    return _loggers.putIfAbsent(name, () => Logger(name));
  }
}
