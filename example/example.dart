import 'dart:developer';

import 'package:youtube_results/youtube_results.dart';

void main() async {
  try {
    // "Change all log to print to see the results in a Dart project.

    final youtube = YoutubeResults();

    // Sample test data
    String query = "Flutter tutorial";
    String channelId = "UCwXdFgeE9KYzlDdR7TG9cMw";
    String playlistId = "PLjxrf2q8roU2z-h4tG3T_4ORhqyfzYLlh";
    String videoId = '4AoFA19gbLo';

    log("Fetching search results for query: $query...");
    List searchResults = await youtube.fetchSearchResults(query);
    log('${searchResults.length}');

    List suggestions = await youtube.fetchSuggestions(query);
    log('${suggestions[0]}');

    log("\nFetching videos for query: $query...");
    List<Video>? videos = await youtube.fetchVideos(query);
    log('''
      title: ${videos?[0].title}
      videoId: ${videos?[0].videoId}
      duration: ${videos?[0].duration}
      viewCount: ${videos?[0].viewCount}
      publishedTime: ${videos?[0].publishedTime}
      channelName: ${videos?[0].channelName}
      channelUrl: ${videos?[0].channelUrl}
      description: ${videos?[0].description}
      thumbnail url: ${videos?[0].thumbnails?[0].url}
      thumbnail height: ${videos?[0].thumbnails?[0].height}
      thumbnail width: ${videos?[0].thumbnails?[0].width}
      videos length : ${videos?.length}''');

    log("\nFetching channels for query: $query...");
    List<Channel>? channels = await youtube.fetchChannels(query);
    log('''
      title: ${channels?[0].title}
      channelId: ${channels?[0].channelId}
      channelUrl: ${channels?[0].channelUrl}
      subscriptionCount: ${channels?[0].subscriptionCount}
      description: ${channels?[0].description}
      thumbnail url: ${channels?[0].thumbnails?[0].url}
      thumbnail height: ${channels?[0].thumbnails?[0].height}
      thumbnail width: ${channels?[0].thumbnails?[0].width}
      channels length : ${channels?.length}''');

    log("\nFetching playlists for query: $query...");
    List<Playlist>? playlists = await youtube.fetchPlaylists(query);
    log('''
      title: ${playlists?[0].title}
      playListId: ${playlists?[0].playListId}
      channelName: ${playlists?[0].channelName}
      channelUrl: ${playlists?[0].channelUrl}
      videoCount: ${playlists?[0].videoCount}
      thumbnail url: ${playlists?[0].thumbnails?[0].url}
      thumbnail height: ${playlists?[0].thumbnails?[0].height}
      thumbnail width: ${playlists?[0].thumbnails?[0].width}
      playlists length : ${playlists?.length}''');

    log("\nFetching channel info for channel ID: $channelId...");
    ChannelInfo? channelInfo = await youtube.fetchChannelInfo(channelId);

    log('''
      Title: ${channelInfo?.title}  
      URL: ${channelInfo?.url}
      Subscription Count: ${channelInfo?.subscriptionCount}
      Video Count: ${channelInfo?.videoCount}
      Description: ${channelInfo?.description}
      items: ${channelInfo?.items?.length}
  
  ''');

    log("\nFetching playlist info for playlist ID: $playlistId...");
    PlaylistInfo? playlistInfo = await youtube.fetchPlaylistInfo(playlistId);
    log('''
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

    log("\nFetching video info for video ID: $videoId...");
    VideoInfo? videoInfo = await youtube.fetchVideoInfo(videoId);
    log('''
     Title: ${videoInfo?.title}
     publishedTime: ${videoInfo?.publishedTime}
     view Count: ${videoInfo?.viewCount}
     likes: ${videoInfo?.likes}
     channelName: ${videoInfo?.channelName}
     channelId: ${videoInfo?.channelId}
     channelUrl: ${videoInfo?.url}
     subscriptionCount: ${videoInfo?.subscriptionCount}
     description: ${videoInfo?.description}
     channelThumbnail : ${videoInfo?.channelThumbnails?[0].url}
     items: ${videoInfo?.items?.length}
''');
  } catch (e, stackTrace) {
    log('here is your bug $e and $stackTrace');
  }
}

/// Helper function to log results
void logResults(List<dynamic> results) async {
  int videoCout = 0;
  int channelCount = 0;
  int playlistCount = 0;
  int relatedShort = 0;
  int relatedVideo = 0;
  int reletedVideolength = 0;
  int relatedShortslength = 0;

  for (var element in results) {
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
  }

  log("Video: $videoCout");
  log("Channel: $channelCount");
  log("Playlist: $playlistCount");

  log("Related Videos: $relatedVideo length: $reletedVideolength");
  log('Related shorts $relatedShort length: $relatedShortslength');
}
