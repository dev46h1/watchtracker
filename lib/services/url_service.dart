import 'package:url_launcher/url_launcher.dart';

class UrlService {
  static Future<void> openYouTubeVideo(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      
      // Try to launch with YouTube app first, then fallback to browser
      bool launched = false;
      
      // First try to open with YouTube app
      if (uri.host.contains('youtube.com') || uri.host.contains('youtu.be')) {
        try {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          launched = true;
        } catch (e) {
          // YouTube app launch failed, will try browser
          launched = false;
        }
      }
      
      // If YouTube app launch failed, try with browser
      if (!launched) {
        if (await canLaunchUrl(uri)) {
          await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
        } else {
          throw 'No application found to open YouTube videos. Please install YouTube app or a web browser.';
        }
      }
    } catch (e) {
      throw 'Could not open video: ${e.toString()}';
    }
  }

  static bool isValidYouTubeUrl(String url) {
    final youtubeRegex = RegExp(
      r'^(https?://)?(www\.)?(youtube\.com/watch\?v=|youtu\.be/|youtube\.com/embed/|youtube\.com/v/)',
      caseSensitive: false,
    );
    return youtubeRegex.hasMatch(url);
  }

  static String extractVideoTitle(String url) {
    final uri = Uri.parse(url);
    String videoId = '';
    
    if (uri.host.contains('youtube.com')) {
      videoId = uri.queryParameters['v'] ?? '';
    } else if (uri.host.contains('youtu.be')) {
      videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
    }
    
    return videoId.isNotEmpty ? 'YouTube Video ($videoId)' : 'YouTube Video';
  }
}
