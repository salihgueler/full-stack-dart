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

  var server = await shelf_io.serve(handler, 'localhost', 8080);

  // Enable content compression
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}
