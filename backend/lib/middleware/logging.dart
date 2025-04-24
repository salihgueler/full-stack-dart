import 'package:shelf/shelf.dart';
import '../utils/logger.dart';

/// Custom logging middleware
Middleware logRequests() {
  final logger = AppLogger.getLogger('HttpMiddleware');

  return (Handler innerHandler) {
    return (Request request) async {
      final startTime = DateTime.now();
      logger.info('${request.method} ${request.url} - Started at $startTime');

      try {
        final response = await innerHandler(request);
        final endTime = DateTime.now();
        final duration = endTime.difference(startTime);

        logger.info(
            '${request.method} ${request.url} - ${response.statusCode} - ${duration.inMilliseconds}ms');

        return response;
      } catch (e, stackTrace) {
        logger.severe(
            '${request.method} ${request.url} - Error: $e', e, stackTrace);
        rethrow;
      }
    };
  };
}
