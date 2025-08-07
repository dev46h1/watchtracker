import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'dart:async';
import 'screens/home_screen.dart';
import 'screens/add_video_screen.dart';
import 'services/url_service.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(const WatchTrackerApp());
}

class WatchTrackerApp extends StatefulWidget {
  const WatchTrackerApp({super.key});

  @override
  State<WatchTrackerApp> createState() => _WatchTrackerAppState();
}

class _WatchTrackerAppState extends State<WatchTrackerApp> {
  late StreamSubscription _intentSub;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      _handleSharedContent(value);
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      _handleSharedContent(value);
      ReceiveSharingIntent.instance.reset();
    });
  }

  void _handleSharedContent(List<SharedMediaFile> sharedFiles) {
    if (sharedFiles.isNotEmpty) {
      final sharedContent = sharedFiles.first;
      
      if (sharedContent.type == SharedMediaType.text && sharedContent.path.isNotEmpty) {
        final sharedText = sharedContent.path;
        
        if (UrlService.isValidYouTubeUrl(sharedText)) {
          _navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (context) => AddVideoScreen(initialUrl: sharedText),
            ),
          ).then((result) {
            // Simply pop back to the existing HomeScreen
            if (result == true) {
              // Just pop back - the HomeScreen will be refreshed when it becomes visible again
              // No need to rebuild the entire navigation stack
            }
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _intentSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      navigatorObservers: [routeObserver],
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
