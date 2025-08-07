import 'package:flutter/material.dart';
import '../models/video.dart';
import '../services/storage_service.dart';
import '../services/url_service.dart';

class AddVideoScreen extends StatefulWidget {
  final String? initialUrl;
  
  const AddVideoScreen({super.key, this.initialUrl});

  @override
  State<AddVideoScreen> createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  
  List<String> _categories = [];
  String? _selectedCategory;
  bool _isLoading = false;
  bool _isFetchingTitle = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    
    if (widget.initialUrl != null) {
      _urlController.text = widget.initialUrl!;
      _autoFillTitle();
    }
  }

  Future<void> _loadCategories() async {
    final categories = await StorageService.getCategories();
    setState(() {
      _categories = categories;
      _selectedCategory = categories.isNotEmpty ? categories[0] : null;
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _saveVideo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final video = Video(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        url: _urlController.text.trim(),
        category: _selectedCategory ?? 'General',
        dateAdded: DateTime.now(),
      );

      final videos = await StorageService.getVideos();
      videos.add(video);
      await StorageService.saveVideos(videos);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving video: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _addNewCategory() async {
    final category = _categoryController.text.trim();
    if (category.isNotEmpty && !_categories.contains(category)) {
      await StorageService.addCategory(category);
      await _loadCategories();
      setState(() {
        _selectedCategory = category;
        _categoryController.clear();
      });
    }
  }

  Future<void> _autoFillTitle() async {
    final url = _urlController.text.trim();
    if (url.isNotEmpty && _titleController.text.isEmpty && UrlService.isValidYouTubeUrl(url)) {
      setState(() {
        _isFetchingTitle = true;
      });
      
      try {
        final title = await UrlService.extractVideoTitle(url);
        if (mounted && _titleController.text.isEmpty) {
          _titleController.text = title;
        }
      } catch (e) {
      } finally {
        if (mounted) {
          setState(() {
            _isFetchingTitle = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Video'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'YouTube URL',
                  hintText: 'https://www.youtube.com/watch?v=...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a YouTube URL';
                  }
                  if (!UrlService.isValidYouTubeUrl(value.trim())) {
                    return 'Please enter a valid YouTube URL';
                  }
                  return null;
                },
                onChanged: (_) => _autoFillTitle(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Video Title',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.title),
                  suffixIcon: _isFetchingTitle 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : null,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a video title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _categoryController,
                      decoration: const InputDecoration(
                        labelText: 'New Category',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.add),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addNewCategory,
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isLoading ? null : _saveVideo,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Save Video'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
