
# **youtube_results** 📺🔍

A Flutter package that allows you to retrieve YouTube search results efficiently. With features like searching for **videos, playlists, channels**, or **all at once** using a query, **searching by video, playlist, or channel ID**, and fetching **YouTube Shorts** if available, this package provides a smooth and powerful way to interact with YouTube's API.

It also leverages the power of **Isolates** (using Flutter's `compute` function) to extract and process JSON data, improving performance and ensuring that your app remains responsive.

---

## **✨ Features**

- **Search by Query**: Search for **videos, playlists, channels**, or **all at once** using a single query.
- **Search by ID**: Retrieve specific **videos, playlists, or channels** by their unique ID.
- **Optimized with Isolates**: Uses **Isolates** (via Flutter's `compute` function) to fetch and process JSON data asynchronously, ensuring smooth and responsive performance.
- **Supports Flutter and any platform**: The package is designed for **Flutter apps** (Android, iOS, Web) but can be used in any platform.
- **Fetch Related Videos and Shorts**: If **YouTube Shorts** or **related videos** are available, they are retrieved with a special class `Related<T>` containing the title and related videos list.
- **Fetch Suggestions**: Fetch video suggestions based on a query.

---

## **🚀 Installation**

1. Add `youtube_results` to your `pubspec.yaml` file:
   ```yaml
   dependencies:
     youtube_results: ^1.0.0
   ```

2. Run:
   ```sh
   flutter pub get
   ```

---

## **🔧 Usage**

### Example Code:
 #### Initialize with your API key or set it as it is.
```dart
import 'package:youtube_results/youtube_results.dart';

void main() async {

  /// Initialize with your API key
  final youtube = YoutubeResults();

  // Sample test data
  String query = "Flutter tutorial";
  String channelId = "UCwXdFgeE9KYzlDdR7TG9cMw";
  String playlistId = "PLjxrf2q8roU2z-h4tG3T_4ORhqyfzYLlh";

```
#### Retrieve all results based on search query
 ``` dart
  List searchResults = await youtube.fetchSearchResults(query);
  print("Fetching search results for query: $query...");
  print(searchResults);
  ```
#### Get suggestions based on search query
 ``` dart
  List suggestions = await youtube.fetchSuggestions(query);
  print(suggestions);
  ```
#### Fetch video using search query
 ``` dart
  print("Fetching videos for query: $query...");
  List<Video>? videos = await youtube.fetchVideos(query);
  print('''
      title: ${videos?[0].title}
      videoId: ${videos?[0].videoId}
      duration: ${videos?[0].duration}
      viewCount: ${videos?[0].viewCount}
      publishedTime: ${videos?[0].publishedTime}
      channelUrl: ${videos?[0].channelUrl}
      channelName: ${videos?[0].channelName}
      description: ${videos?[0].description}
      thumbnail url: ${videos?[0].thumbnails?[0].url}
      video length: ${videos?.length}''');
```
#### Fetch channels using search query
``` dart
  print("Fetching channels for query: $query...");
  List<Channel>? channels = await youtube.fetchChannels(query);
  print('''
      title: ${channels?[0].title}
      channelId: ${channels?[0].channelId}
      channelUrl: ${channels?[0].channelUrl}
      subscriptionCount: ${channels?[0].subscriptionCount}
      description: ${channels?[0].description}
      thumbnail url: ${channels?[0].thumbnails?[0].url}''');
```
#### Fetch playlist using search query
``` dart
  print("Fetching playlists for query: $query...");
  List<Playlist>? playlists = await youtube.fetchPlaylists(query);
  print('''
      title: ${playlists?[0].title}
      playListId: ${playlists?[0].playListId}
      channelName: ${playlists?[0].channelName}
      channelUrl: ${playlists?[0].channelUrl}
      videoCount: ${playlists?[0].videoCount}
      thumbnail url: ${playlists?[0].thumbnails?[0].url}''');
```
#### Fetch data about a channel using channelId
``` dart
  print("Fetching channel info for channel ID: $channelId...");
  ChannelInfo? channelInfo = await youtube.fetchChannelInfo(channelId);
  print('''
  Title: ${channelInfo?.title}  
  URL: ${channelInfo?.url}
  Subscription Count: ${channelInfo?.subscriptionCount}
  Video Count: ${channelInfo?.videoCount}
  Description: ${channelInfo?.description}
  items: ${channelInfo?.items?.length}
  ''');
 ```
 ### 💡 Tip
#### ChannelInfo may contain several objects, so be sure to check their types before using them:
  - **`Video`**
  - **`Playlist`**
  - **`Related<Short>`**
  - **`Related<Video>`**

#### Fetch data about a playlist using playlistId
``` dart
  print("Fetching playlist info for playlist ID: $playlistId...");
  PlaylistInfo? playlistInfo = await youtube.fetchPlaylistInfo(playlistId);
  print('''
  Title: ${playlistInfo?.title}
  URL: ${playlistInfo?.url}
  view Count: ${playlistInfo?.viewCount}
  Video Count: ${playlistInfo?.videoCount}
  Description: ${playlistInfo?.description}
  channelName: ${playlistInfo?.channelName}
  channelThumbnail: ${playlistInfo?.channelThumbnails?[0].url}''');
}
```

### Helper Function to Print Results:
```dart
void printResults(List<dynamic> results) async {
  int videoCount = 0;
  int channelCount = 0;
  int playlistCount = 0;
  int relatedShort = 0;
  int relatedVideo = 0;
  int relatedVideoLength = 0;
  int relatedShortLength = 0;

  results.forEach((element) {
    if (element is Related<Shorts>) {
      relatedShort++;
      relatedShortLength += element.relatedVideos?.length as int;
    } else if (element is Related<Video>) {
      relatedVideo++;
      relatedVideoLength += element.relatedVideos?.length as int;
    } else if (element is Channel) {
      channelCount++;
    } else if (element is Playlist) {
      playlistCount++;
    } else if (element is Video) {
      videoCount++;
    }
  });

  print("Video: $videoCount");
  print("Channel: $channelCount");
  print("Playlist: $playlistCount");
  print("Related Videos: $relatedVideo length: $relatedVideoLength");
  print("Related Shorts: $relatedShort length: $relatedShortLength");
}
```

---

## **⚡ Powered by Isolates**
`youtube_results` uses **Isolates** (via Flutter's `compute` function) to efficiently fetch and decode JSON data, offloading the work from the main UI thread for better performance. This ensures that your app remains fast and responsive even during heavy data processing.

---

## **📝 Remark**  
- **YouTube Shorts** and **Related Videos** can't be directly retrieved unless they are available in search results or if you're using a **videoId**.
- When available, Shorts and related videos are returned as **Related<Shorts>** or **`Related<Video>`**.  
- `Related<T>` is a class that contains:  
  - `String? title`  
  - `List<T>? relatedVideos`  

---

## **👨‍💻 Contributing**  
We welcome contributions! Feel free to **fork** the repository, create a **feature branch**, and submit a **Pull Request**.

### **Steps to Contribute:**
1. **Fork the repo**: Click the "Fork" button on GitHub to create your own copy of the repository.
2. **Create a new feature branch**:  
   ```sh
   git checkout -b feature-name
   ```
3. **Make your changes** and commit them:
   ```sh
   git commit -m "Add new feature"
   ```
4. **Push to your fork**:
   ```sh
   git push origin feature-name
   ```
5. **Submit a Pull Request** (PR) to the main repo.

---

## **📜 License**  
This project is licensed under the **MIT License**. See the [LICENSE](./LICENSE) file for details.

---

## **💬 Feel free to open issues**  
If you find bugs or have feature requests, feel free to open an **issue** in the GitHub repo. We’re happy to help!

---
