import 'package:url_launcher/url_launcher.dart';

class UrlService {
  static Future<void> openYouTubeVideo(String url) async {
    final Uri uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
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
