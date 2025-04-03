import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current URL to generate QR code
    final currentUrl = Uri.base.toString();
    // For development, use localhost:8080 to ensure it points to the backend server
    final baseUrl = Uri.base.toString().contains('localhost') 
        ? 'http://localhost:8080' 
        : Uri.base.origin;
    final audienceUrl = '$baseUrl/#/audience';
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emoji Reaction Counter'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Full Stack Development with Dart',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Real-time Emoji Reaction Counter',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/presenter');
                    },
                    icon: const Icon(Icons.present_to_all),
                    label: const Text('Presenter View'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/audience');
                    },
                    icon: const Icon(Icons.people),
                    label: const Text('Audience View'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              const Text(
                'Scan this QR code to join as audience:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              QrImageView(
                data: audienceUrl,
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: 8),
              SelectableText(
                audienceUrl,
                style: const TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
