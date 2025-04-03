import 'package:shelf/shelf.dart';

/// Custom logging middleware
Middleware logRequests() {
  return (Handler innerHandler) {
    return (Request request) async {
      final startTime = DateTime.now();
      print('${request.method} ${request.url} - Started at $startTime');
      
      try {
        final response = await innerHandler(request);
        final endTime = DateTime.now();
        final duration = endTime.difference(startTime);
        
        print('${request.method} ${request.url} - ${response.statusCode} - ${duration.inMilliseconds}ms');
        
        return response;
      } catch (e, stackTrace) {
        print('${request.method} ${request.url} - Error: $e');
        print(stackTrace);
        rethrow;
      }
    };
  };
}
