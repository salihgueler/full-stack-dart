import 'package:serverpod/serverpod.dart';
import '../protocol/emoji_reaction.dart';
import '../protocol/emoji_counts.dart';

class EmojiChannel extends SerializationChannel {
  @override
  String get name => 'emoji';

  // Channel for emoji reactions
  static final channelReaction = 'reaction';
  
  // Channel for emoji counts
  static final channelCounts = 'counts';

  // Broadcast a reaction to all connected clients
  static Future<void> broadcastReaction(
    Server server,
    EmojiReaction reaction,
  ) async {
    await server.serverpod.sendStreamMessage(
      EmojiChannel().name,
      channelReaction,
      reaction,
    );
  }

  // Broadcast updated counts to all connected clients
  static Future<void> broadcastCounts(
    Server server,
    EmojiCounts counts,
  ) async {
    await server.serverpod.sendStreamMessage(
      EmojiChannel().name,
      channelCounts,
      counts,
    );
  }
}
