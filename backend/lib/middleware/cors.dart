import 'package:shelf/shelf.dart';

/// Middleware to handle CORS (Cross-Origin Resource Sharing)
Middleware corsMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      // Handle preflight requests
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders);
      }

      // Handle normal requests
      final response = await innerHandler(request);
      return response.change(headers: {
        ..._corsHeaders,
        ...response.headers,
      });
    };
  };
}

// CORS headers to allow all origins
const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Auth-Token',
  'Access-Control-Allow-Credentials': 'true',
  'Access-Control-Max-Age': '86400', // 24 hours
};
