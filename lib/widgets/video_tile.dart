import 'package:flutter/material.dart';
import '../models/video.dart';
import '../services/url_service.dart';

class VideoTile extends StatelessWidget {
  final Video video;
  final VoidCallback onToggleWatched;
  final VoidCallback onDelete;

  const VideoTile({
    super.key,
    required this.video,
    required this.onToggleWatched,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: Checkbox(
          value: video.isWatched,
          onChanged: (_) => onToggleWatched(),
          activeColor: Colors.green,
        ),
        title: Text(
          video.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            decoration: video.isWatched ? TextDecoration.lineThrough : null,
            color: video.isWatched ? Colors.grey : null,
            fontWeight: video.isWatched ? FontWeight.normal : FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category: ${video.category}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              'Added: ${_formatDate(video.dateAdded)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.red),
              onPressed: () async {
                try {
                  await UrlService.openYouTubeVideo(video.url);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Could not open video: $e')),
                    );
                  }
                }
              },
              tooltip: 'Open Video',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: onDelete,
              tooltip: 'Delete Video',
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
