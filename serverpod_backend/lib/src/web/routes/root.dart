import 'dart:io';

import 'package:serverpod/serverpod.dart';

class RouteRoot extends WidgetRoute {
  @override
  Future<Widget> build(Session session, HttpRequest request) async {
    return Template(
      children: [
        Html('''
<!DOCTYPE html>
<html>
<head>
  <title>Emoji Reaction App - Serverpod</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    body { 
      font-family: Arial, sans-serif; 
      text-align: center; 
      padding: 20px;
      max-width: 800px;
      margin: 0 auto;
      line-height: 1.6;
    }
    h1 { color: #333; }
    .container {
      background-color: #f5f5f5;
      border-radius: 8px;
      padding: 20px;
      margin-top: 30px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    code {
      background-color: #e0e0e0;
      padding: 2px 5px;
      border-radius: 3px;
      font-family: monospace;
    }
  </style>
</head>
<body>
  <h1>Emoji Reaction App - Serverpod Backend</h1>
  <p>This is the Serverpod implementation of the emoji reaction backend.</p>
  
  <div class="container">
    <h2>WebSocket Information</h2>
    <p>WebSocket endpoint is available at: <code>ws://${request.requestedUri.authority}/ws</code></p>
    <p>Connect your Flutter frontend to this endpoint to use the Serverpod backend.</p>
  </div>
</body>
</html>
        '''),
      ],
    );
  }
}
