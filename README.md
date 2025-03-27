
# **youtube_results** 📺🔍

A Flutter package that allows you to retrieve YouTube search results efficiently. With features like searching for **videos, playlists, channels**, or **all at once** using a query, **searching by video, playlist, or channel ID**, and fetching **YouTube Shorts** if available, this package provides a smooth and powerful way to interact with YouTube's API.

It also leverages the power of **Isolates** (using `Isolate.run` function) to extract and process JSON data, improving performance and ensuring that your app remains responsive.

---

## **✨ Features**

- **Search by Query**: Search for **videos, playlists, channels**, or **all at once** using a single query.
- **Search by ID**: Retrieve specific **videos, playlists, or channels** by their unique ID.
- **Optimized with Isolates**: Uses **Isolates** (via Flutter's `Isolate.run` function) to fetch and process JSON data asynchronously, ensuring smooth and responsive performance.
- **Supports Flutter and any platform**: The package is designed for **Flutter apps** (Android, iOS, Web) but can be used in any platform.
- **Fetch Related Videos and Shorts**: If **YouTube Shorts** or **related videos** are available, they are retrieved with a special class `Related<T>` containing the title and related videos list.
- **Fetch Suggestions**: Fetch video suggestions based on a query.

---

## **🚀 Installation**

1. Add `youtube_results` to your `pubspec.yaml` file:
   ```yaml
   dependencies:
     youtube_results: ^0.0.2
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
#### Retrieve all results based on a search query
 ``` dart

  List searchResults = await youtube.fetchSearchResults(query);

  ```
#### Get suggestions based on a search query
 ``` dart

  List suggestions = await youtube.fetchSuggestions(query);
  
  ```
#### Fetch videos using a search query
 ``` dart

  List<Video>? videos = await youtube.fetchVideos(query);
  
```
#### Fetch channels using a search query
``` dart
  
  List<Channel>? channels = await youtube.fetchChannels(query);

```
#### Fetch playlists using a search query
``` dart
  
  List<Playlist>? playlists = await youtube.fetchPlaylists(query);

```
#### Fetch channel details using channelId
``` dart
  
  ChannelInfo? channelInfo = await youtube.fetchChannelInfo(channelId);
  
 ```
 ### 💡 Tip
#### ChannelInfo may contain several objects, so be sure to check their types before using them:
  - **`Video`**
  - **`Playlist`**
  - **`Related<Short>`**
  - **`Related<Video>`**

#### Fetch playlist details using playlistId
``` dart
  
  PlaylistInfo? playlistInfo = await youtube.fetchPlaylistInfo(playlistId);
 
 } 
```
---
## **📂 Example**
  For more details, check the [exmaple](./example/example.dart)
---
---

## **⚡ Powered by Isolates**
`youtube_results` uses **Isolates** (via Flutter's `Isolate.run` function) to efficiently fetch and decode JSON data, offloading the work from the main UI thread for better performance. This ensures that your app remains fast and responsive even during heavy data processing.

---

## **📝 Remark**  
- **YouTube Shorts** and **Related Videos** can't be directly retrieved unless they are available in search results or if you're using a **videoId**.
- When available, Shorts and related videos are returned as **Related<Shorts>** or **`Related<Video>`**.  
- `Related<T>` is a class that contains:  
  - `String? title`  
  - `List<T>? relatedVideos`  

---

## **Contributing**  
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
---

## 🚀 Future Plans

We're continuously working to improve `youtube_results`. Here are some upcoming features:

### 🔄 Load More Functionality

- **Pagination Support**: Enable **pagination** for search results, allowing users to fetch additional results efficiently.
- **`loadMore` Feature**: Provide a **`loadMore`** function for each search types, making it easier to implement **infinite scrolling**.

Stay tuned for updates! 

---

## **📜 License**  
This project is licensed under the **MIT License**. See the [LICENSE](./LICENSE) file for details.

---

## **💬 Feel free to open issues**  
If you find bugs or have feature requests, feel free to open an **issue** in the GitHub repo. We’re happy to help!

---
