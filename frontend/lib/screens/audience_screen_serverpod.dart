import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/serverpod_websocket_service.dart';
import '../widgets/connection_status_serverpod.dart';

class AudienceScreen extends StatefulWidget {
  const AudienceScreen({super.key});

  @override
  State<AudienceScreen> createState() => _AudienceScreenState();
}

class _AudienceScreenState extends State<AudienceScreen> {
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
        title: const Text('Audience View (Serverpod Style)'),
        actions: const [
          ConnectionStatusServerpod(),
          SizedBox(width: 16),
        ],
      ),
      body: Consumer<ServerpodWebSocketService>(
        builder: (context, service, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Send your reaction!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                // Emoji reaction buttons
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: service.emojiCounts.keys.map((emoji) {
                    return EmojiButton(
                      emoji: emoji,
                      onPressed: () {
                        service.sendReaction(emoji);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),
                // Reaction counts
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: service.emojiCounts.entries.map((entry) {
                    return Column(
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontSize: 24),
                        ),
                        Text(
                          '${entry.value}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class EmojiButton extends StatelessWidget {
  final String emoji;
  final VoidCallback onPressed;
  
  const EmojiButton({
    super.key,
    required this.emoji,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ),
      ),
    );
  }
}
