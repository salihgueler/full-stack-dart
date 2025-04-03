import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class EmojiAnimation extends StatelessWidget {
  final List<String> reactions;
  
  const EmojiAnimation({
    super.key,
    required this.reactions,
  });

  @override
  Widget build(BuildContext context) {
    // If there are no reactions, return an empty container
    if (reactions.isEmpty) {
      return const SizedBox.shrink();
    }
    
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Stack(
      children: List.generate(reactions.length, (index) {
        // Get the emoji for this animation
        final emoji = reactions[index];
        
        // Create a unique key for each animation to ensure it's not rebuilt
        final key = ValueKey('emoji_$index');
        
        // Create a random generator seeded with the index for consistent randomness
        final random = Random(index);
        
        // Random horizontal position across the entire screen width
        final horizontalPosition = random.nextDouble() * screenWidth;
        
        // Start from top of screen
        const verticalPosition = 0.0;
        
        // Random duration for falling animation (1.5 to 3 seconds)
        final duration = (1500 + random.nextInt(1500)).ms;
        
        // Random rotation
        final rotation = (random.nextDouble() - 0.5) * 2 * pi / 4;
        
        // Random size variation (24-40)
        final size = 24.0 + random.nextInt(16);
        
        // Random horizontal drift as it falls
        final horizontalDrift = (random.nextDouble() - 0.5) * 100;
        
        return Positioned(
          key: key,
          left: horizontalPosition,
          top: verticalPosition,
          child: Text(
            emoji,
            style: TextStyle(fontSize: size),
          )
          .animate()
          .fadeIn(duration: 300.ms)
          .then()
          .moveY(
            begin: 0,
            end: screenHeight,
            curve: Curves.easeIn,
            duration: duration,
          )
          .moveX(
            begin: 0,
            end: horizontalDrift,
            curve: Curves.easeInOut,
            duration: duration,
          )
          .rotate(
            begin: 0,
            end: rotation,
            duration: duration,
          )
          .fadeOut(
            delay: duration - 500.ms,
            duration: 500.ms,
          ),
        );
      }),
    );
  }
}
