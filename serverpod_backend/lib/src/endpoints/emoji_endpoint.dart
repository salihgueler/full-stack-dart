import 'package:serverpod/serverpod.dart';
import '../protocol/emoji_reaction.dart';
import '../protocol/emoji_counts.dart';
import '../websockets/emoji_channel.dart';

class EmojiEndpoint extends Endpoint {
  // Store emoji reaction counts
  static final Map<String, int> _emojiCounts = {
    '👍': 0,
    '❤️': 0,
    '😂': 0,
    '😮': 0,
    '👏': 0,
    '🎉': 0,
  };

  // Get current emoji counts
  Future<EmojiCounts> getCounts(Session session) async {
    return EmojiCounts(counts: Map.from(_emojiCounts));
  }

  // Add a new reaction
  Future<void> addReaction(Session session, String emoji) async {
    if (_emojiCounts.containsKey(emoji)) {
      _emojiCounts[emoji] = (_emojiCounts[emoji] ?? 0) + 1;
      
      // Create reaction object
      final reaction = EmojiReaction(
        emoji: emoji,
        timestamp: DateTime.now(),
      );
      
      // Broadcast to all clients
      await EmojiChannel.broadcastReaction(session.server, reaction);
      
      // Broadcast updated counts
      await EmojiChannel.broadcastCounts(
        session.server, 
        EmojiCounts(counts: Map.from(_emojiCounts)),
      );
    }
  }
}
