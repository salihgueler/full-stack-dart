import 'package:shelf/shelf.dart';

/// Middleware to handle CORS (Cross-Origin Resource Sharing)
Middleware corsMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        // Handle preflight requests
        return Response.ok('', headers: _corsHeaders);
      }
      
      // Handle actual request
      final response = await innerHandler(request);
      return response.change(headers: {...response.headers, ..._corsHeaders});
    };
  };
}

// CORS headers to allow all origins
const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': 'Origin, Content-Type, X-Auth-Token, Accept',
  'Access-Control-Allow-Credentials': 'true',
};
