import 'package:serverpod/serverpod.dart';

class EmojiReaction extends SerializableEntity {
  final String emoji;
  final DateTime timestamp;

  EmojiReaction({
    required this.emoji,
    required this.timestamp,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  static EmojiReaction fromJson(Map<String, dynamic> json) {
    return EmojiReaction(
      emoji: json['emoji'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
