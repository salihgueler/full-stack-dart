import 'package:serverpod_emoji_counter_client/serverpod_emoji_counter_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'dart:async';
import 'package:qr_flutter/qr_flutter.dart';

// Sets up a singleton client object that can be used to talk to the server from
// anywhere in our app. The client is generated from your server code.
// The client is set up to connect to a Serverpod running on a local server on
// the default port. You will need to modify this to connect to staging or
// production servers.
var client = Client('http://$localhost:8080/')
  ..connectivityMonitor = FlutterConnectivityMonitor();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoji Reaction App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emoji Reaction App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PresenterScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Presenter View'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AudienceScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Audience View'),
            ),
          ],
        ),
      ),
    );
  }
}

class PresenterScreen extends StatefulWidget {
  const PresenterScreen({super.key});

  @override
  PresenterScreenState createState() => PresenterScreenState();
}

class PresenterScreenState extends State<PresenterScreen> {
  final Map<String, int> _reactionCounts = {};
  final List<Reaction> _recentReactions = [];
  StreamSubscription<Reaction>? _reactionSubscription;
  bool _isConnected = false;
  String _connectionStatus = 'Connecting...';

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  Future<void> _connectToServer() async {
    setState(() {
      _connectionStatus = 'Connecting...';
      _isConnected = false;
    });

    try {
      // Open streaming connection
      await client.openStreamingConnection();
      
      // Get initial reaction counts
      final counts = await client.reaction.getReactionCounts();
      setState(() {
        _reactionCounts.clear();
        _reactionCounts.addAll(counts);
      });
      
      // Subscribe to reaction stream
      _reactionSubscription = client.reaction.streamReactions().listen(
        _onReaction,
        onError: _onError,
        onDone: _onDisconnect,
      );
      
      setState(() {
        _connectionStatus = 'Connected';
        _isConnected = true;
      });
    } catch (e) {
      setState(() {
        _connectionStatus = 'Connection failed: $e';
        _isConnected = false;
      });
      
      // Try to reconnect after a delay
      Future.delayed(const Duration(seconds: 3), _connectToServer);
    }
  }

  void _onReaction(Reaction reaction) {
    setState(() {
      // Update reaction count
      _reactionCounts[reaction.emoji] = (_reactionCounts[reaction.emoji] ?? 0) + 1;
      
      // Add to recent reactions
      _recentReactions.add(reaction);
      
      // Keep only the last 20 reactions
      if (_recentReactions.length > 20) {
        _recentReactions.removeAt(0);
      }
    });
  }

  void _onError(error) {
    setState(() {
      _connectionStatus = 'Error: $error';
      _isConnected = false;
    });
    
    // Try to reconnect after a delay
    Future.delayed(const Duration(seconds: 3), _connectToServer);
  }

  void _onDisconnect() {
    setState(() {
      _connectionStatus = 'Disconnected';
      _isConnected = false;
    });
    
    // Try to reconnect after a delay
    Future.delayed(const Duration(seconds: 3), _connectToServer);
  }

  Future<void> _resetCounts() async {
    try {
      await client.reaction.resetReactionCounts();
      setState(() {
        _reactionCounts.clear();
        _recentReactions.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reset counts: $e')),
      );
    }
  }

  @override
  void dispose() {
    _reactionSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 600;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presenter View'),
        actions: [
          ConnectionStatusIndicator(isConnected: _isConnected, status: _connectionStatus),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCounts,
            tooltip: 'Reset Counts',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: ReactionCountsDisplay(counts: _reactionCounts),
                ),
                if (isLargeScreen)
                  Expanded(
                    flex: 1,
                    child: QRCodeDisplay(),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: ReactionAnimationArea(reactions: _recentReactions),
          ),
          if (!isLargeScreen)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: QRCodeDisplay(),
            ),
        ],
      ),
    );
  }
}

class ConnectionStatusIndicator extends StatelessWidget {
  final bool isConnected;
  final String status;

  const ConnectionStatusIndicator({
    super.key,
    required this.isConnected,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isConnected ? Icons.cloud_done : Icons.cloud_off,
            color: isConnected ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Text(status),
        ],
      ),
    );
  }
}

class ReactionCountsDisplay extends StatelessWidget {
  final Map<String, int> counts;

  const ReactionCountsDisplay({
    super.key,
    required this.counts,
  });

  @override
  Widget build(BuildContext context) {
    final sortedEmojis = counts.keys.toList()
      ..sort((a, b) => (counts[b] ?? 0).compareTo(counts[a] ?? 0));

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: counts.isEmpty ? 1 : sortedEmojis.length,
      itemBuilder: (context, index) {
        if (counts.isEmpty) {
          return const Center(
            child: Text('No reactions yet'),
          );
        }
        
        final emoji = sortedEmojis[index];
        final count = counts[emoji] ?? 0;
        
        return Card(
          elevation: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 8),
              Text(
                '$count',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ReactionAnimationArea extends StatelessWidget {
  final List<Reaction> reactions;

  const ReactionAnimationArea({
    super.key,
    required this.reactions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(
          top: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      child: Stack(
        children: [
          for (var i = 0; i < reactions.length; i++)
            AnimatedReaction(
              key: ValueKey('${reactions[i].emoji}-${reactions[i].timestamp.millisecondsSinceEpoch}'),
              reaction: reactions[i],
              index: i,
            ),
        ],
      ),
    );
  }
}

class AnimatedReaction extends StatefulWidget {
  final Reaction reaction;
  final int index;

  const AnimatedReaction({
    super.key,
    required this.reaction,
    required this.index,
  });

  @override
  AnimatedReactionState createState() => AnimatedReactionState();
}

class AnimatedReactionState extends State<AnimatedReaction> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _leftPosition;

  @override
  void initState() {
    super.initState();
    
    // Random horizontal position
    _leftPosition = 50.0 + (widget.index * 20) % 300;
    
    // Animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    // Animation that moves from bottom to top
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _leftPosition,
      bottom: _animation.value * MediaQuery.of(context).size.height * 0.25,
      child: Opacity(
        opacity: 1.0 - _animation.value * 0.5,
        child: Text(
          widget.reaction.emoji,
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}

class QRCodeDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // URL for audience to join
    final audienceUrl = 'http://$localhost:8080/';
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Join as audience:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            QrImageView(
              data: audienceUrl,
              version: QrVersions.auto,
              size: 150,
            ),
            const SizedBox(height: 8),
            Text(
              audienceUrl,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AudienceScreen extends StatefulWidget {
  const AudienceScreen({super.key});

  @override
  AudienceScreenState createState() => AudienceScreenState();
}

class AudienceScreenState extends State<AudienceScreen> {
  bool _isConnected = false;
  String _connectionStatus = 'Connecting...';
  
  final List<String> _emojis = [
    '👍', '❤️', '😂', '🎉', '👏',
    '🔥', '🚀', '💯', '🙌', '😍',
    '🤔', '😮', '😢', '👎', '😡',
  ];

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  Future<void> _connectToServer() async {
    setState(() {
      _connectionStatus = 'Connecting...';
      _isConnected = false;
    });

    try {
      // Open streaming connection
      await client.openStreamingConnection();
      
      setState(() {
        _connectionStatus = 'Connected';
        _isConnected = true;
      });
    } catch (e) {
      setState(() {
        _connectionStatus = 'Connection failed: $e';
        _isConnected = false;
      });
      
      // Try to reconnect after a delay
      Future.delayed(const Duration(seconds: 3), _connectToServer);
    }
  }

  Future<void> _sendReaction(String emoji) async {
    if (!_isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not connected to server')),
      );
      return;
    }

    try {
      final reaction = Reaction(emoji: emoji, timestamp: DateTime.now());
      await client.reaction.sendReaction(reaction);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send reaction: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audience View'),
        actions: [
          ConnectionStatusIndicator(isConnected: _isConnected, status: _connectionStatus),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 100,
          childAspectRatio: 1.0,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: _emojis.length,
        itemBuilder: (context, index) {
          final emoji = _emojis[index];
          
          return InkWell(
            onTap: () => _sendReaction(emoji),
            child: Card(
              elevation: 2,
              child: Center(
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
