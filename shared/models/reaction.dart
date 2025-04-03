/// Model representing an emoji reaction
class Reaction {
  final String emoji;
  final DateTime timestamp;
  
  Reaction({
    required this.emoji,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
  
  /// Create a Reaction from JSON
  factory Reaction.fromJson(Map<String, dynamic> json) {
    return Reaction(
      emoji: json['emoji'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
  
  /// Convert Reaction to JSON
  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
