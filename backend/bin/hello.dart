import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final router = Router();

  var handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(router);

  router.get('/hello/<name>', (Request request, String name) {
    return Response.ok('Hello $name');
  });

  // Get port from environment variable or use 8080 as default
  var port = int.parse(Platform.environment['PORT'] ?? '8080');
  var server = await shelf_io.serve(handler, '0.0.0.0', port);

  // Enable content compression
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}
