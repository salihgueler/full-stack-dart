import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/websocket_service.dart';

class ConnectionStatus extends StatelessWidget {
  const ConnectionStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WebSocketService>(
      builder: (context, service, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                service.isConnected ? Icons.wifi : Icons.wifi_off,
                color: service.isConnected ? Colors.green : Colors.red,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                service.isConnected ? 'Connected' : 'Disconnected',
                style: TextStyle(
                  color: service.isConnected ? Colors.green : Colors.red,
                  fontSize: 12,
                ),
              ),
              if (service.error.isNotEmpty) ...[
                const SizedBox(width: 8),
                Tooltip(
                  message: service.error,
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.orange,
                    size: 16,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
