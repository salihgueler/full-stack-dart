/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class Reaction
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Reaction._({
    required this.emoji,
    required this.timestamp,
  });

  factory Reaction({
    required String emoji,
    required DateTime timestamp,
  }) = _ReactionImpl;

  factory Reaction.fromJson(Map<String, dynamic> jsonSerialization) {
    return Reaction(
      emoji: jsonSerialization['emoji'] as String,
      timestamp:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
    );
  }

  String emoji;

  DateTime timestamp;

  /// Returns a shallow copy of this [Reaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Reaction copyWith({
    String? emoji,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'emoji': emoji,
      'timestamp': timestamp.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ReactionImpl extends Reaction {
  _ReactionImpl({
    required String emoji,
    required DateTime timestamp,
  }) : super._(
          emoji: emoji,
          timestamp: timestamp,
        );

  /// Returns a shallow copy of this [Reaction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Reaction copyWith({
    String? emoji,
    DateTime? timestamp,
  }) {
    return Reaction(
      emoji: emoji ?? this.emoji,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
