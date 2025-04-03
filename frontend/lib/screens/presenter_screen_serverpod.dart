import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../services/serverpod_websocket_service.dart';
import '../widgets/emoji_counter.dart';
import '../widgets/emoji_animation.dart';
import '../widgets/connection_status_serverpod.dart';

class PresenterScreen extends StatefulWidget {
  const PresenterScreen({super.key});

  @override
  State<PresenterScreen> createState() => _PresenterScreenState();
}

class _PresenterScreenState extends State<PresenterScreen> {
  @override
  void initState() {
    super.initState();
    // Connect to WebSocket when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final service = Provider.of<ServerpodWebSocketService>(context, listen: false);
      service.connect();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presenter View (Serverpod Style)'),
        actions: const [
          ConnectionStatusServerpod(),
          SizedBox(width: 16),
        ],
      ),
      body: Consumer<ServerpodWebSocketService>(
        builder: (context, service, child) {
          return Stack(
            children: [
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Emoji Reactions',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Emoji counters
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: service.emojiCounts.entries.map((entry) {
                        return EmojiCounter(
                          emoji: entry.key,
                          count: entry.value,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 64),
                    // QR code for audience
                    Column(
                      children: [
                        const Text(
                          'Scan to participate:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        QrImageView(
                          data: '${Uri.base.origin}/#/audience',
                          version: QrVersions.auto,
                          size: 200.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Emoji animations
              EmojiAnimation(reactions: service.recentReactions),
            ],
          );
        },
      ),
    );
  }
}
