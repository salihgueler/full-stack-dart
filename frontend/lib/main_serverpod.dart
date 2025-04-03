import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/serverpod_websocket_service.dart';
import 'screens/home_screen.dart';
import 'screens/presenter_screen_serverpod.dart';
import 'screens/audience_screen_serverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ServerpodWebSocketService(),
      child: MaterialApp(
        title: 'Emoji Reaction Counter (Serverpod Style)',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/presenter': (context) => const PresenterScreen(),
          '/audience': (context) => const AudienceScreen(),
        },
      ),
    );
  }
}
