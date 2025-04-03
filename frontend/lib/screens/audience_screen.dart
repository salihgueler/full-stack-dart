import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/websocket_service.dart';
import '../widgets/emoji_button.dart';
import '../widgets/connection_status.dart';

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
      final service = Provider.of<WebSocketService>(context, listen: false);
      service.connect();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audience View'),
        actions: [
          // Connection status indicator
          const ConnectionStatus(),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          ),
        ],
      ),
      body: Consumer<WebSocketService>(
        builder: (context, service, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Send your reaction!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  
                  // Emoji reaction buttons
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      EmojiButton(
                        emoji: '👍',
                        onPressed: () => service.sendReaction('👍'),
                      ),
                      EmojiButton(
                        emoji: '❤️',
                        onPressed: () => service.sendReaction('❤️'),
                      ),
                      EmojiButton(
                        emoji: '😂',
                        onPressed: () => service.sendReaction('😂'),
                      ),
                      EmojiButton(
                        emoji: '😮',
                        onPressed: () => service.sendReaction('😮'),
                      ),
                      EmojiButton(
                        emoji: '👏',
                        onPressed: () => service.sendReaction('👏'),
                      ),
                      EmojiButton(
                        emoji: '🎉',
                        onPressed: () => service.sendReaction('🎉'),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Show counts
                  const Text(
                    'Reaction Counts:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    children: service.emojiCounts.entries.map((entry) {
                      return Chip(
                        avatar: Text(entry.key),
                        label: Text('${entry.value}'),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
