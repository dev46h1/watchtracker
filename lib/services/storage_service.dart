import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/video.dart';

class StorageService {
  static const String _videosKey = 'videos';
  static const String _categoriesKey = 'categories';

  static Future<List<Video>> getVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final videosJson = prefs.getStringList(_videosKey) ?? [];
    
    return videosJson
        .map((json) => Video.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> saveVideos(List<Video> videos) async {
    final prefs = await SharedPreferences.getInstance();
    final videosJson = videos
        .map((video) => jsonEncode(video.toJson()))
        .toList();
    
    await prefs.setStringList(_videosKey, videosJson);
  }

  static Future<List<String>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_categoriesKey) ?? ['General', 'Tutorials', 'Entertainment', 'Music'];
  }

  static Future<void> saveCategories(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_categoriesKey, categories);
  }

  static Future<void> addCategory(String category) async {
    final categories = await getCategories();
    if (!categories.contains(category)) {
      categories.add(category);
      await saveCategories(categories);
    }
  }
}
