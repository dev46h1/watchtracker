import 'package:flutter/material.dart';
import '../models/video.dart';
import '../services/storage_service.dart';
import '../widgets/video_tile.dart';
import 'add_video_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Video> _videos = [];
  List<Video> _filteredVideos = [];
  List<String> _categories = [];
  String? _selectedCategory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final videos = await StorageService.getVideos();
      final categories = await StorageService.getCategories();
      
      setState(() {
        _videos = videos;
        _categories = ['All', ...categories];
        _selectedCategory = 'All';
        _filteredVideos = _getSortedVideos(videos);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  List<Video> _getSortedVideos(List<Video> videos) {
    List<Video> filteredVideos = videos;
    
    if (_selectedCategory != null && _selectedCategory != 'All') {
      filteredVideos = videos.where((video) => video.category == _selectedCategory).toList();
    }
    
    filteredVideos.sort((a, b) {
      if (a.isWatched != b.isWatched) {
        return a.isWatched ? 1 : -1;
      }
      return b.dateAdded.compareTo(a.dateAdded);
    });
    
    return filteredVideos;
  }

  void _filterVideos(String? category) {
    setState(() {
      _selectedCategory = category;
      _filteredVideos = _getSortedVideos(_videos);
    });
  }

  Future<void> _toggleWatched(Video video) async {
    final updatedVideo = video.copyWith(isWatched: !video.isWatched);
    final videoIndex = _videos.indexWhere((v) => v.id == video.id);
    
    if (videoIndex != -1) {
      setState(() {
        _videos[videoIndex] = updatedVideo;
        _filteredVideos = _getSortedVideos(_videos);
      });
      
      await StorageService.saveVideos(_videos);
    }
  }

  Future<void> _deleteVideo(Video video) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Video'),
        content: Text('Are you sure you want to delete "${video.title.length > 50 ? '${video.title.substring(0, 50)}...' : video.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _videos.removeWhere((v) => v.id == video.id);
        _filteredVideos = _getSortedVideos(_videos);
      });
      
      await StorageService.saveVideos(_videos);
    }
  }

  Future<void> _navigateToAddVideo() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => const AddVideoScreen()),
    );
    
    if (result == true) {
      await _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WatchTracker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: _filterVideos,
            itemBuilder: (context) {
              return _categories.map((category) {
                return PopupMenuItem<String>(
                  value: category,
                  child: Row(
                    children: [
                      Icon(
                        _selectedCategory == category
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(category),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredVideos.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    _buildStatsBar(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredVideos.length,
                        itemBuilder: (context, index) {
                          final video = _filteredVideos[index];
                          return VideoTile(
                            video: video,
                            onToggleWatched: () => _toggleWatched(video),
                            onDelete: () => _deleteVideo(video),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddVideo,
        tooltip: 'Add Video',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_library_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _selectedCategory == 'All' 
                ? 'No videos added yet'
                : 'No videos in "$_selectedCategory" category',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add your first video',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    final totalVideos = _filteredVideos.length;
    final watchedVideos = _filteredVideos.where((v) => v.isWatched).length;
    final unwatchedVideos = totalVideos - watchedVideos;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Total', totalVideos, Icons.video_library),
          _buildStatItem('Unwatched', unwatchedVideos, Icons.play_circle_outline),
          _buildStatItem('Watched', watchedVideos, Icons.check_circle),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
