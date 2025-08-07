# WatchTracker 📺

A Flutter-based Android app for managing your YouTube video watchlist with categories and progress tracking.

## Download 📱

**[Download the latest APK](../../releases/download/v1.1.2/WatchTracker-V1.1.2.apk)**

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
- **🔗 Share Integration**: Share videos directly from YouTube app to WatchTracker
- **🚫 Duplicate Prevention**: Automatic detection and prevention of duplicate videos
- **🏷️ Auto-Title Fetching**: Automatically fetches video titles from YouTube URLs

<!-- ## Screenshots 📱

*Add screenshots of your app here* -->

## How to Use 📖

### Adding Videos

#### Method 1: From within the app
1. Tap the **+** (Add) button on the home screen
2. Enter the YouTube URL (the app validates YouTube links)
3. Title will be auto-populated from YouTube (can edit if you want to customize)
4. Select or create a category
5. Tap **Save Video**

#### Method 2: Share from YouTube app
1. Open any YouTube video in the YouTube app
2. Tap the **Share** button
3. Select **WatchTracker** from the sharing options
4. The app will open with the video URL pre-filled
5. Review the auto-fetched title and category, then tap **Save Video**

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

### Smart Features

#### Duplicate Detection
- The app automatically detects if you're trying to add a video that's already in your watchlist
- Uses YouTube video ID matching to prevent duplicates
- Shows a helpful message with the existing video's title if a duplicate is found

#### Auto-Title Fetching
- When you paste a YouTube URL, the app automatically fetches the video title
- Uses YouTube's API to get accurate titles
- Falls back to a default format if fetching fails
- Shows a loading indicator while fetching

#### Share Integration
- Integrated with Android's sharing system
- Appears as an option when sharing from YouTube or other apps
- Automatically validates shared URLs to ensure they're YouTube links
- Seamlessly opens the add video screen with pre-filled data

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

### Statistics Dashboard
- **Total Videos**: Shows your complete watchlist count
- **Unwatched**: Videos you haven't watched yet
- **Watched**: Videos you've completed
- **Category Filtering**: Statistics update based on selected category

## Technical Details 🔧

### Storage
- Uses local device storage (SharedPreferences)
- No internet required after video titles are fetched
- Data persists between app sessions

### Permissions
- **Internet**: Required for fetching video titles and opening YouTube links
- **Query All Packages**: Allows the app to detect and open YouTube app

### Integration Features
- **YouTube App Integration**: Prioritizes opening videos in YouTube app
- **Browser Fallback**: Falls back to browser if YouTube app isn't available
- **Share Intent Handling**: Receives shared content from other apps

---

**Made with ❤️ by 46h1**