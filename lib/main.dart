import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const WatchTrackerApp());
}

class WatchTrackerApp extends StatelessWidget {
  const WatchTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WatchTracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
