# WatchTracker 📺

A Flutter-based Android app for managing your YouTube video watchlist with categories and progress tracking.

## Download 📱

**[Download the latest APK](../../releases/download/v1.0.0/WatchTracker-V1.0.1.apk)**

*Keep checking this repo for future updates!*

## Features ✨

- **📋 Video Management**: Add, organize, and track your YouTube videos
- **✅ Watch Progress**: Mark videos as watched/unwatched with checkboxes
- **🏷️ Categories**: Organize videos into custom categories (General, Tutorials, Entertainment, Music, etc.)
- **🔍 Filtering**: Filter videos by category to find what you need quickly
- **📊 Statistics**: View total, watched, and unwatched video counts
- **🎯 Smart Sorting**: Watched videos automatically move to the bottom, unwatched stay at the top
- **▶️ Direct Launch**: Open YouTube videos directly from the app
- **💾 Persistent Storage**: All data saved locally on your device

<!-- ## Screenshots 📱

*Add screenshots of your app here* -->

## How to Use 📖

### Adding Videos
1. Tap the **+** (Add) button on the home screen
2. Enter the YouTube URL (the app validates YouTube links)
3. Title will be autopopulated (can edit if you want to customize)
4. Select or create a category
5. Tap **Save Video**

### Managing Videos
- **Mark as Watched**: Check the checkbox next to any video
- **Open Video**: Tap the play button (▶️) to launch the video in YouTube
- **Delete Video**: Tap the delete button (🗑️) and confirm deletion
- **Filter by Category**: Use the filter menu in the app bar

### Categories
- **Default Categories**: General, Tutorials, Entertainment, Music
- **Custom Categories**: Add new categories when adding videos
- **Filter Videos**: Use the filter button to view videos by category

## How It Works 🔧

### Smart Sorting
Videos are automatically sorted with:
1. **Unwatched videos** at the top
2. **Watched videos** at the bottom
3. **Newest videos first** within each group

### Supported YouTube URLs
The app validates and accepts:
- `https://www.youtube.com/watch?v=VIDEO_ID`
- `https://youtu.be/VIDEO_ID`
- `https://youtube.com/embed/VIDEO_ID`
- `https://youtube.com/v/VIDEO_ID`

---

**Made with ❤️ by 46h1**