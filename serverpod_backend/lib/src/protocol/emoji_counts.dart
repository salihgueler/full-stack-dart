import 'package:serverpod/serverpod.dart';

class EmojiCounts extends SerializableEntity {
  final Map<String, int> counts;

  EmojiCounts({
    required this.counts,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'counts': counts,
    };
  }

  static EmojiCounts fromJson(Map<String, dynamic> json) {
    final rawCounts = json['counts'] as Map<String, dynamic>;
    final typedCounts = rawCounts.map((key, value) => MapEntry(key, value as int));
    
    return EmojiCounts(
      counts: typedCounts,
    );
  }
}
