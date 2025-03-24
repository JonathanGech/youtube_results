import 'package:youtube_results/youtube_results.dart';


void main() async {
  // Initialize with your API key
  final youtube = YoutubeResults();

  // Sample test data
  String query = "Flutter tutorial";
  String channelId = "UCwXdFgeE9KYzlDdR7TG9cMw";
  String playlistId = "PLjxrf2q8roU2z-h4tG3T_4ORhqyfzYLlh";

  print("Fetching search results for query: $query...");
  List searchResults = await youtube.fetchSearchResults(query);
  print(searchResults);

  List suggestions = await youtube.fetchSuggestions(query);
  print(suggestions);

  print("\nFetching videos for query: $query...");
  List<Video>? videos = await youtube.fetchVideos(query);
  print('''
      title: ${videos?[0].title}
      videoId: ${videos?[0].videoId}
      videoId: ${videos?[0].duration}
      viewCount: ${videos?[0].viewCount}
      viewCount: ${videos?[0].publishedTime}
      channelUrl: ${videos?[0].channelUrl}
      viewCount: ${videos?[0].channelName}
      description: ${videos?[0].description}
      thumbnail url: ${videos?[0].thumbnails?[0].url}
      thumbnail height: ${videos?[0].thumbnails?[0].height}
      thumbnail width: ${videos?[0].thumbnails?[0].width}
      playlists length : ${videos?.length}''');

  print("\nFetching channels for query: $query...");
  List<Channel>? channels = await youtube.fetchChannels(query);
  print('''
      title: ${channels?[0].title}
      channelId: ${channels?[0].channelId}
      channelUrl: ${channels?[0].channelUrl}
      subscriptionCount: ${channels?[0].subscriptionCount}
      description: ${channels?[0].description}
      thumbnail url: ${channels?[0].thumbnails?[0].url}
      thumbnail height: ${channels?[0].thumbnails?[0].height}
      thumbnail width: ${channels?[0].thumbnails?[0].width}
      channels length : ${channels?.length}''');

  print("\nFetching playlists for query: $query...");
  List<Playlist>? playlists = await youtube.fetchPlaylists(query);
  print('''
      title: ${playlists?[0].title}
      playListId: ${playlists?[0].playListId}
      channelName: ${playlists?[0].channelName}
      channelUrl: ${playlists?[0].channelUrl}
      videoCount: ${playlists?[0].videoCount}
      thumbnail url: ${playlists?[0].thumbnails?[0].url}
      thumbnail height: ${playlists?[0].thumbnails?[0].height}
      thumbnail width: ${playlists?[0].thumbnails?[0].width}
      playlists length : ${playlists?.length}''');

  print("\nFetching channel info for channel ID: $channelId...");
  ChannelInfo? channelInfo = await youtube.fetchChannelInfo(channelId);

  print('''
  Title: ${channelInfo?.title}  
  URL: ${channelInfo?.url}
  Subscription Count: ${channelInfo?.subscriptionCount}
  Video Count: ${channelInfo?.videoCount}
  Description: ${channelInfo?.description}
  items: ${channelInfo?.items?.length}
  
  ''');

  print("\nFetching playlist info for playlist ID: $playlistId...");
  PlaylistInfo? playlistInfo = await youtube.fetchPlaylistInfo(playlistId);
  print('''
  Title: ${playlistInfo?.title}
  URL: ${playlistInfo?.url}
  view Count: ${playlistInfo?.viewCount}
  Video Count: ${playlistInfo?.videoCount}
  Description: ${playlistInfo?.description}
  channelName: ${playlistInfo?.channelName}
   channelThumbnail : ${playlistInfo?.channelThumbnails?[0].url}
  thumbnail : ${playlistInfo?.thumbnails?[0].url}
  items: ${playlistInfo?.items?.length}
''');
}

/// Helper function to print results
void printResults(List<dynamic> results) async {
  int videoCout = 0;
  int channelCount = 0;
  int playlistCount = 0;
  int relatedShort = 0;
  int relatedVideo = 0;
  int reletedVideolength = 0;
  int relatedShortslength = 0;

  results.forEach((element) {
    if (element is Related<Shorts>) {
      relatedShort++;
      relatedShortslength += element.relatedVideos?.length as int;
    } else if (element is Related<Video>) {
      relatedVideo++;
      reletedVideolength += element.relatedVideos?.length as int;
    } else if (element is Channel) {
      channelCount++;
    } else if (element is Playlist) {
      playlistCount++;
    } else if (element is Video) {
      videoCout++;
    }
  });

  print("Video: $videoCout");
  print("Channel: $channelCount");
  print("Playlist: $playlistCount");

  print("Related Videos: $relatedVideo length: $reletedVideolength");
  print('Related shorts $relatedShort length: $relatedShortslength');
}
