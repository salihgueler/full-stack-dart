import 'dart:async';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ReactionEndpoint extends Endpoint {
  // Create a broadcast stream controller to manage reactions
  static final StreamController<Reaction> _reactionController = 
      StreamController<Reaction>.broadcast();
  
  // Map to store reaction counts
  static final Map<String, int> _reactionCounts = {};

  // Stream method to get reactions in real-time
  Stream<Reaction> streamReactions(Session session) async* {
    session.log('Client connected to reaction stream');
    
    // Yield all reactions from the broadcast stream
    await for (final reaction in _reactionController.stream) {
      yield reaction;
    }
  }

  // Method to send a reaction
  Future<void> sendReaction(Session session, Reaction reaction) async {
    session.log('Received reaction: ${reaction.emoji}');
    
    // Update reaction count
    _reactionCounts[reaction.emoji] = (_reactionCounts[reaction.emoji] ?? 0) + 1;
    
    // Add reaction to the broadcast stream
    _reactionController.add(reaction);
  }

  // Method to get current reaction counts
  Future<Map<String, int>> getReactionCounts(Session session) async {
    return _reactionCounts;
  }

  // Method to reset all reaction counts
  Future<void> resetReactionCounts(Session session) async {
    _reactionCounts.clear();
    session.log('Reaction counts reset');
  }
}
