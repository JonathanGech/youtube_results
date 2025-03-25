import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import 'Models/channel.dart';
import 'Models/channel_info.dart';
import 'Models/playlist.dart';
import 'Models/playlist_info.dart';
import 'Models/thumbnail.dart';
import 'Models/video.dart';
import 'utils/extract_resource.dart';
import 'utils/helper_functions.dart';
import 'utils/helper_extension.dart';

/// A class to handle YouTube search results and tokens.
///
/// This class manages various tokens used for YouTube API requests,
/// including search, video, channel, and playlist tokens. It also
/// stores the last query made and the API key used for authentication.
///
/// The [YoutubeResults] constructor allows you to initialize the
/// [apiKey] and [maxAttempts] properties.
///
class YoutubeResults {
  final http.Client _client = http.Client();
  final ReceivePort _receivePort = ReceivePort();

  /// - `_searchToken`: Token for the search results.
  String? _searchToken;

  /// - `_videoToken`: Token for the video results.
  String? _videoToken;

  /// - `_channelToken`: Token for the channel results.
  String? _channelToken;

  /// - `_playListToken`: Token for the playlist results.
  String? _playListToken;

  /// - `lastQuery`: The last search query made.
  String? lastQuery;

  /// - `apiKey`: The API key used for YouTube API requests.
  String? apiKey;

  /// - `maxAttempts`: The maximum number of attempts for API requests.
  int? maxAttempts;

  /// Constructor for [YoutubeResults].
  /// Initializes the [apiKey] and [maxAttempts] properties.
  YoutubeResults({this.apiKey, this.maxAttempts});

  /// 💡 Fetches general search results (videos, shorts, channels, playlists, Related).

  Future<List<dynamic>> fetchSearchResults(
    String query,
  ) async {
    return _fetchResults<dynamic>(
      query: query,
      urlSuffix: '',
      filterCondition: (item) => true,
      updateToken: (token) => _searchToken = token,
      token: _searchToken,
    );
  }

  /// 💡 Fetches only videos matching the search query.

  Future<List<Video>?> fetchVideos(
    String query,
  ) async {
    return _fetchResults<Video>(
      query: query,
      urlSuffix: '&sp=EgIQAQ%253D%253D',
      filterCondition: (item) => item is Video,
      updateToken: (token) => _videoToken = token,
      token: _videoToken,
    );
  }

  /// 💡 Fetches channels matching the search query.

  Future<List<Channel>?> fetchChannels(
    String query,
  ) async {
    return _fetchResults<Channel>(
      query: query,
      urlSuffix: '&sp=EgIQAg%253D%253D',
      filterCondition: (item) => item is Channel,
      updateToken: (token) => _channelToken = token,
      token: _channelToken,
    );
  }

  /// 💡 Fetches playlists matching the search query.

  Future<List<Playlist>?> fetchPlaylists(
    String query,
  ) async {
    return _fetchResults<Playlist>(
      query: query,
      urlSuffix: '&sp=EgIQAw%253D%253D',
      filterCondition: (item) => item is Playlist,
      updateToken: (token) => _playListToken = token,
      token: _playListToken,
    );
  }

  /// 💡 Fetches detailed information about a specific channel.

  Future<ChannelInfo?> fetchChannelInfo(String channelId) async {
    return _fetchPageData<ChannelInfo>(
      url: 'https://www.youtube.com/channel/$channelId',
      extractContent: _extractChannelContent,
      extractMetaData: _extractChannelMetadata,
      extractItems: ExtractResource.extractChannelData,
      updateToken: (token) => _channelToken = token,
      extractToken: _extractChannelContinuationToken,
      logMessage: 'Channel info extracted successfully',
    );
  }

  /// 💡 Fetches detailed information about a specific playlist.

  Future<PlaylistInfo?> fetchPlaylistInfo(String playlistId) async {
    return _fetchPageData<PlaylistInfo>(
      url: 'https://www.youtube.com/playlist?list=$playlistId',
      extractContent: _extractPlayListContent,
      extractMetaData: _extractPlaylistMetadata,
      extractItems: ExtractResource.extractPlaylistData,
      updateToken: (token) => _playListToken = token,
      extractToken: _extractPlaylistContinuationToken,
      logMessage: 'Playlist info extracted successfully',
    );
  }

  /// 💡 Fetches search suggestions based on the query.
  Future<List<String>> fetchSuggestions(String query) async {
    const baseUrl =
        'http://suggestqueries.google.com/complete/search?output=toolbar&ds=yt&q=';
    final response =
        await fetchWithRetry('$baseUrl$query', maxAttempts: maxAttempts ?? 3);

    if (response.statusCode != 200) return [];

    final transformer = Xml2Json()..parse(response.body);
    final jsonData = jsonDecode(transformer.toGData());

    return (jsonData['toplevel']['CompleteSuggestion'] as List)
        .map((s) => s['suggestion']['data'].toString())
        .toList();
  }

  /// Generalized function to fetch search results and filter specific content.

  Future<List<T>> _fetchResults<T>({
    required String query,
    required String urlSuffix,
    required bool Function(dynamic) filterCondition,
    required void Function(String?) updateToken,
    String? token,
  }) async {
    List<T> results = [];

    try {
      if (token != null &&
          query == lastQuery &&
          apiKey != null &&
          apiKey != '') {
        return _fetchContinuationResults() as List<T>;
      }
      lastQuery = query;
      final jsonMap = await _extractResponse(
          'https://www.youtube.com/results?search_query=$query$urlSuffix');
      if (jsonMap != null) {
        final contents = _extractSearchContent(jsonMap);
        if (contents != null) {
          final extractedItems = ExtractResource.extractAllItems(contents);
          results = extractedItems.where(filterCondition).cast<T>().toList();
        }
        updateToken(_extractSearchContinuationToken(jsonMap));
      } else {
        log('Response returned null');
      }
    } catch (e, stackTrace) {
      log('Error loading for $T messeage: $e');
      log('Stack trace: $stackTrace');
    }

    return results;
  }

  /// Generalized function to fetch detailed page data.

  Future<T?> _fetchPageData<T>({
    required String url,
    required List<dynamic>? Function(Map<String, dynamic>) extractContent,
    required Map<String, dynamic>? Function(Map<String, dynamic>)
        extractMetaData,
    required List<dynamic> Function(List<dynamic>) extractItems,
    required Function(String?) updateToken,
    required String? Function(Map<String, dynamic>) extractToken,
    required String logMessage,
  }) async {
    try {
      final jsonMap = await _extractResponse(url);
      if (jsonMap != null) {
        var contents = extractContent(jsonMap);
        var metaData = extractMetaData(jsonMap);
        if (contents != null) {
          var result = extractItems(contents);
          updateToken(extractToken(jsonMap));
          return T == ChannelInfo
              ? ChannelInfo(
                  title: metaData?['title'],
                  description: metaData?['description'],
                  url: metaData?['url'],
                  subscriptionCount: metaData?['subscribersCount'],
                  videoCount: metaData?['videoCount'],
                  thumbnails: metaData?['thumbnails'],
                  banner: metaData?['banner'],
                  items: result,
                ) as T
              : PlaylistInfo(
                  title: metaData?['title'],
                  description: metaData?['description'],
                  url: metaData?['url'],
                  viewCount: metaData?['viewCount'],
                  channelName: metaData?['channelName'],
                  channelThumbnails: metaData?['channelThumbnails'],
                  videoCount: metaData?['videoCount'],
                  thumbnails: metaData?['thumbnails'],
                  items: result,
                ) as T;
        }
      }
    } catch (e, stackTrace) {
      log('Error loading info $T');
      log('Stack trace: $stackTrace');
    }
    return null;
  }

  ///  Handles fetching additional search results when a continuation token is available.
  Future<List<dynamic>> _fetchContinuationResults() async {
    return [];
  }

  /// Extracts search content from the response.

  List<dynamic>? _extractSearchContent(Map<String, dynamic> jsonMap) {
    return jsonMap
        .getMap('contents')
        ?.getMap('twoColumnSearchResultsRenderer')
        ?.getMap('primaryContents')
        ?.getMap('sectionListRenderer')
        ?.getList('contents')
        ?.elementAtSafe(0)
        ?.getMap('itemSectionRenderer')
        ?.getList('contents');
  }

  ///  Extracts channel content from the response.

  List<dynamic>? _extractChannelContent(Map<String, dynamic> jsonMap) {
    return jsonMap
        .getMap('contents')
        ?.getMap('twoColumnBrowseResultsRenderer')
        ?.getList('tabs')
        ?.elementAtSafe(0)
        ?.getMap('tabRenderer')
        ?.getMap('content')
        ?.getMap('sectionListRenderer')
        ?.getList('contents');
  }

  /// Extracts playlist content from the response.

  List<dynamic>? _extractPlayListContent(Map<String, dynamic> jsonMap) {
    return jsonMap
        .getMap('contents')
        ?.getMap('twoColumnBrowseResultsRenderer')
        ?.getList('tabs')
        ?.elementAtSafe(0)
        ?.getMap('tabRenderer')
        ?.getMap('content')
        ?.getMap('sectionListRenderer')
        ?.getList('contents')
        ?.elementAtSafe(0)
        ?.getMap('itemSectionRenderer')
        ?.getList('contents');
  }

  /// Extracts the channel metadata from the JSON data.

  Map<String, dynamic>? _extractChannelMetadata(Map<String, dynamic> jsonMap) {
    var result = jsonMap
        .getMap('header')
        ?.getMap('pageHeaderRenderer')
        ?.getMap('content')
        ?.getMap('pageHeaderViewModel');

    String? title = result
        ?.getMap('title')
        ?.getMap('dynamicTextViewModel')
        ?.getMap('text')
        ?.getT<String>('content');
    String? description = result
        ?.getMap('description')
        ?.getMap('descriptionPreviewViewModel')
        ?.getMap('description')
        ?.getT<String>('content');

    List<Thumbnail?> thumbnails = ExtractResource.getThumbnails(result
        ?.getMap('image')
        ?.getMap('decoratedAvatarViewModel')
        ?.getMap('avatar')
        ?.getMap('avatarViewModel')
        ?.getMap('image')
        ?.getList('source'));
    List<Thumbnail?> banner = ExtractResource.getThumbnails(result
        ?.getMap('banner')
        ?.getMap('imageBannerViewModel')
        ?.getMap('image')
        ?.getList('source'));

    String? url = result
        ?.getMap('metadata')
        ?.getMap('contentMetadataViewModel')
        ?.getList('metadataRows')
        ?.elementAtSafe(0)
        ?.getList('metadataParts')
        ?.elementAtSafe(0)
        ?.getMap('text')
        ?.getT<String>('content')
        ?.substring(1);

    String? subscribersCount = result
        ?.getMap('metadata')
        ?.getMap('contentMetadataViewModel')
        ?.getList('metadataRows')
        ?.elementAtSafe(1)
        ?.getList('metadataParts')
        ?.elementAtSafe(0)
        ?.getMap('text')
        ?.getT<String>('content');
    String? videoCount = result
        ?.getMap('metadata')
        ?.getMap('contentMetadataViewModel')
        ?.getList('metadataRows')
        ?.elementAtSafe(1)
        ?.getList('metadataParts')
        ?.elementAtSafe(1)
        ?.getMap('text')
        ?.getT<String>('content');

    return {
      'title': title,
      'description': description,
      'thumbnails': thumbnails,
      'banner': banner,
      'url': url,
      'subscribersCount': subscribersCount,
      'videoCount': videoCount,
    };
  }

  /// Extracts the playlist metadata from the JSON response.

  Map<String, dynamic>? _extractPlaylistMetadata(Map<String, dynamic> jsonMap) {
    var result = jsonMap
        .getMap('header')
        ?.getMap('pageHeaderRenderer')
        ?.getMap('content')
        ?.getMap('pageHeaderViewModel');

    String? title = result
        ?.getMap('title')
        ?.getMap('dynamicTextViewModel')
        ?.getMap('text')
        ?.getT<String>('content');
    String? description = result
        ?.getMap('description')
        ?.getMap('descriptionPreviewViewModel')
        ?.getMap('description')
        ?.getT<String>('content');

    var metadatas = result
        ?.getMap('metadata')
        ?.getMap('contentMetadataViewModel')
        ?.getList('metadataRows');

    String? url = metadatas
        ?.elementAtSafe(0)
        ?.getList('metadataParts')
        ?.elementAtSafe(0)
        ?.getMap('avatarStack')
        ?.getMap('avatarStackViewModel')
        ?.getMap('rendererContext')
        ?.getMap('commandContext')
        ?.getMap('onTap')
        ?.getMap('innertubeCommand')
        ?.getMap('browseEndpoint')
        ?.getT<String>('canonicalBaseUrl')
        ?.substring(1);

    String? channelName = metadatas
        ?.elementAtSafe(0)
        ?.getList('metadataParts')
        ?.elementAtSafe(0)
        ?.getMap('avatarStack')
        ?.getMap('avatarStackViewModel')
        ?.getMap('text')
        ?.getT<String>('content')
        ?.substring(3);

    List<Thumbnail?> channelThumbnail = ExtractResource.getThumbnails(metadatas
        ?.elementAtSafe(0)
        ?.getList('metadataParts')
        ?.elementAtSafe(0)
        ?.getMap('avatarStack')
        ?.getMap('avatarStackViewModel')
        ?.getList('avatars')
        ?.elementAtSafe(0)
        ?.getMap('avatarViewModel')
        ?.getMap('image')
        ?.getList('sources'));

    String? videoCount = metadatas
        ?.elementAtSafe(1)
        ?.getList('metadataParts')
        ?.elementAtSafe(1)
        ?.getMap('text')
        ?.getT<String>('content');

    String? viewCount = metadatas
        ?.elementAtSafe(1)
        ?.getList('metadataParts')
        ?.elementAtSafe(2)
        ?.getMap('text')
        ?.getT<String>('content');

    List<Thumbnail?> thumbnails = ExtractResource.getThumbnails(result
        ?.getMap('heroImage')
        ?.getMap('contentPreviewImageViewModel')
        ?.getMap('image')
        ?.getList('sources'));

    return {
      'title': title,
      'description': description,
      'thumbnails': thumbnails,
      'url': url,
      'channelName': channelName,
      'channelThumbnails': channelThumbnail,
      'viewCount': viewCount,
      'videoCount': videoCount,
    };
  }

  /// Extracts Search continuation token from JSON response.

  String _extractSearchContinuationToken(Map<String, dynamic> jsonMap) {
    return jsonMap
            .getMap('contents')
            ?.getMap('twoColumnSearchResultsRenderer')
            ?.getMap('primaryContents')
            ?.getMap('sectionListRenderer')
            ?.getList('contents')
            ?.firstWhere(
              (item) => item['continuationItemRenderer'] != null,
              orElse: () => {},
            )
            .getMap('continuationEndpoint')
            ?.getMap('continuationCommand')
            ?.getT<String>('token') ??
        '';
  }

  /// Extracts Channel continuation token from JSON response.

  String? _extractChannelContinuationToken(Map<String, dynamic> jsonMap) {
    return jsonMap
        .getMap('contents')
        ?.getMap('twoColumnBrowseResultsRenderer')
        ?.getList('tabs')
        ?.elementAtSafe(0)
        ?.getMap('tabRenderer')
        ?.getMap('content')
        ?.getMap('sectionListRenderer')
        ?.getList('contents')
        ?.firstWhere(
          (item) => item['itemSectionRenderer'] != null,
          orElse: () => {},
        )
        .getList('contents')
        ?.firstWhere(
          (item) => item['continuationItemRenderer'] != null,
          orElse: () => {},
        )
        .getMap('continuationEndpoint')
        ?.getMap('continuationCommand')
        ?.getT<String>('token');
  }

  /// Extracts Channel continuation token from JSON response.

  String? _extractPlaylistContinuationToken(Map<String, dynamic> jsonMap) {
    return jsonMap
        .getMap('contents')
        ?.getMap('twoColumnBrowseResultsRenderer')
        ?.getList('tabs')
        ?.elementAtSafe(0)
        ?.getMap('tabRenderer')
        ?.getMap('content')
        ?.getMap('sectionListRenderer')
        ?.getList('contents')
        ?.firstWhere(
          (item) => item['continuationItemRenderer'] != null,
          orElse: () => {},
        )
        .getMap('continuationEndpoint')
        ?.getMap('continuationCommand')
        ?.getT<String>('token');
  }

  Future<http.Response> fetchWithRetry(String url,
      {int maxAttempts = 3}) async {
    return HelperFunctions.retry(
      () => _client.get(Uri.parse(url)),
      maxAttempts: maxAttempts,
      delay: const Duration(seconds: 2),
    );
  }

// Function that calls the isolate
  FutureOr<Map<String, dynamic>?> _requestAndContent(
      dynamic responseBody) async {
    try {
      final jsonMap = HelperFunctions.getJsonMap(responseBody);
      return jsonMap;
    } catch (e) {
      log('Network failure: $e');
      return null;
    }
  }

// Function that calls the isolate
  Future<Map<String, dynamic>?> _extractResponse(String url) async {
    try {
      final response = await fetchWithRetry(url, maxAttempts: maxAttempts ?? 3);
      if (response.statusCode == 200) {
        final jsonMap = await Isolate.run(() => _requestAndContent(url));
        if (jsonMap != null) {
          return jsonMap;
        } else {
          log('Error response statuscode: ${response.statusCode}');
          return null;
        }
      }
    } catch (e) {
      log('Network failure: $e');
      return null;
    }
    return null;
  }
}
