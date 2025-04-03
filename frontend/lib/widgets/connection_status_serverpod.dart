import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/serverpod_websocket_service.dart';

class ConnectionStatusServerpod extends StatelessWidget {
  const ConnectionStatusServerpod({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ServerpodWebSocketService>(
      builder: (context, service, child) {
        return Row(
          children: [
            Icon(
              service.isConnected ? Icons.wifi : Icons.wifi_off,
              color: service.isConnected ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              service.isConnected ? 'Connected' : 'Disconnected',
              style: TextStyle(
                color: service.isConnected ? Colors.green : Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}
