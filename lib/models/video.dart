class Video {
  final String id;
  final String title;
  final String url;
  final String category;
  bool isWatched;
  final DateTime dateAdded;

  Video({
    required this.id,
    required this.title,
    required this.url,
    required this.category,
    this.isWatched = false,
    required this.dateAdded,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'url': url,
      'category': category,
      'isWatched': isWatched,
      'dateAdded': dateAdded.toIso8601String(),
    };
  }

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      title: json['title'],
      url: json['url'],
      category: json['category'],
      isWatched: json['isWatched'] ?? false,
      dateAdded: DateTime.parse(json['dateAdded']),
    );
  }

  Video copyWith({
    String? id,
    String? title,
    String? url,
    String? category,
    bool? isWatched,
    DateTime? dateAdded,
  }) {
    return Video(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      category: category ?? this.category,
      isWatched: isWatched ?? this.isWatched,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }
}
