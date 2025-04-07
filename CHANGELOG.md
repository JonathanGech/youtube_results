# Changelog
## [0.1.1] - Bug Fix

### Fixes

- **Channel `banner` and `thumbnail`**: Now load correctly as expected.
---

## [0.1.0] - Search Video by ID Now Available

### New Features

- **Search by Video ID**: You can now retrieve video details using a **specific video ID**.

## [0.0.2] - Bug Fix & Improvement

### Changes & Fixes

- **Switched from `compute` to `Isolate.run`**: Now fully supports both **Flutter** and **pure Dart** environments.

This update improves flexibility, allowing the package to work seamlessly in **non-Flutter Dart projects** while maintaining performance optimizations. 

---

## [0.0.1] - Initial Release

### 🚀 Features

- **Search by Query**: Retrieve **videos, playlists, channels**, or **all at once** using a single query.
- **Search by ID**: Fetch specific **videos, playlists, or channels** by their unique ID.
- **YouTube Shorts Support**: Fetch **YouTube Shorts** along with search results (if available).
- **Optimized with Isolates**: Uses **Isolates** (via Flutter's `compute` function) for efficient JSON processing.
- **Fetch Related Videos**: Retrieve **related videos** using a special `Related<T>` class.
- **Fetch Suggestions**: Get video suggestions based on a search query.
- **Cross-Platform Support**: Designed for **Flutter apps** (Android, iOS, Web) but also works with pure Dart.

This is the first release of `youtube_results`, making YouTube search easy and efficient for Flutter developers! 🚀📺🔍
