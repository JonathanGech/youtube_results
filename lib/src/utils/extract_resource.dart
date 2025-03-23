import '../Models/channel.dart';
import '../Models/playlist.dart';
import '../Models/related_videos.dart';
import '../Models/shorts.dart';
import '../Models/thumbnail.dart';
import '../Models/video.dart';

class ExtractResource {
  /// Extracts playlist, channel, video, short, or related videos from JSON data.
  static List<dynamic> extractAllItems(List jsonData) {
    return jsonData
        .map((item) {
          if (item['lockupViewModel'] != null) {
            return _extractPlaylist(item['lockupViewModel']);
          } else if (item['channelRenderer'] != null) {
            return _extractChannel(item['channelRenderer']);
          } else if (item['videoRenderer'] != null) {
            return _extractVideo(item['videoRenderer']);
          } else if (item['reelShelfRenderer'] != null) {
            return _extractShorts(item['reelShelfRenderer']);
          } else if (item['shelfRenderer'] != null) {
            return _extractRelated(item['shelfRenderer']);
          }
          return null;
        })
        .where((item) => item != null)
        .toList();
  }

  static List<dynamic> extractChannelData(List jsonData) {
    return jsonData.expand((item) {
      return item['itemSectionRenderer'] != null
          ? _extractItems(item['itemSectionRenderer']['contents'])
          : [];
    }).toList();
  }

  static List<dynamic> extractPlaylistData(List jsonData) {
    return jsonData.expand((item) {
      return item['playlistVideoListRenderer'] != null
          ? _extractItems(item['playlistVideoListRenderer']['contents'])
          : [];
    }).toList();
  }

  static List<dynamic> _extractItems(List content) {
    return content
        .map((item) {
          if (item['lockupViewModel'] != null) {
            return _extractPlaylist(item['lockupViewModel']);
          } else if (item['videoRenderer'] != null) {
            return _extractVideo(item['videoRenderer']);
          } else if (item['gridVideoRenderer'] != null) {
            return _extractGridVideo(item['gridVideoRenderer']);
          } else if (item['playlistVideoRenderer'] != null) {
            return _extractPlaylistVideo(item['playlistVideoRenderer']);
          } else if (item['reelShelfRenderer'] != null) {
            return _extractShorts(item['reelShelfRenderer']);
          } else if (item['shelfRenderer'] != null) {
            return _extractRelated(item['shelfRenderer']);
          }
          return null;
        })
        .where((item) => item != null)
        .toList();
  }

  static Playlist _extractPlaylist(Map item) {
      return Playlist(
      title: _extractText(item['metadata']?['lockupMetadataViewModel']),
      videoCount: _extractText(item['contentImage']?['collectionThumbnailViewModel']
                  ?['primaryThumbnail']?['thumbnailViewModel']?['overlays']?[0]
              ['thumbnailOverlayBadgeViewModel']?['thumbnailBadges']?[0]
          ?['thumbnailBadgeViewModel']),
      playListId: item['contentId'],
      channelName: _extractText(item['metadata']?['lockupMetadataViewModel']
              ?['metadata']?['contentMetadataViewModel']?['metadataRows']?[0]
          ?['metadataParts']?[0]?['text']),
      channelUrl: item['metadata']?['lockupMetadataViewModel']?['metadata']
                      ?['contentMetadataViewModel']?['metadataRows']?[0]
                  ?['metadataParts']?[0]?['text']?['commandRuns']?[0]?['onTap']
              ?['innertubeCommand']?['browseEndpoint']?['canonicalBaseUrl']?.toString().substring(1),
      thumbnails: getThumbnails(item['contentImage']
              ?['collectionThumbnailViewModel']?['primaryThumbnail']
          ?['thumbnailViewModel']?['image']?['sources']),
    
    );
  }

  static Channel _extractChannel(Map item) {
    return Channel(
      title: _extractText(item['title']),
      channelId: item['channelId'],
      description: _extractText(item['descriptionSnippet']),
      subscriptionCount: _extractText(item['videoCountText']),
      thumbnails: getThumbnails(item['thumbnail']?['thumbnails']),
      
    );
  }

static Related<Shorts>  _extractShorts(Map items)  {
    final title = _extractText(items['title']);
    final contentItems = items['items'];

    if (contentItems is! List) {
      return Related<Shorts>(title: title, relatedVideos: []);
    }

    List<Shorts> results =
        contentItems.map<Shorts>((short) => _extractShortItem(short)).toList();

    return Related<Shorts>(title: title, relatedVideos: results);
  }


  static Shorts _extractShortItem(Map item) {
    return Shorts(
      title: _extractText(
          item['shortsLockupViewModel']?['overlayMetadata']?['primaryText']),
      videoId: item['shortsLockupViewModel']?['onTap']?['innertubeCommand']
          ?['reelWatchEndpoint']?['videoId'],
      viewCount: _extractText(
          item['shortsLockupViewModel']?['overlayMetadata']?['secondaryText']),
      thumbnails: getThumbnails(
          item['shortsLockupViewModel']?['thumbnail']?['sources']),
    );
  }

  static Video _extractVideo(Map item) {
    return Video(
      videoId: item['videoId'],
      title: _extractText(item['title']),
      viewCount: _extractText(item['shortViewCountText']),
      duration: _extractText(item['lengthText']),
      publishedTime: _extractText(item['publishedTimeText']),
      channelName: _extractText(item['longBylineText']),
      channelThumbnails: getThumbnails(
          item['channelThumbnailSupportedRenderers']
                  ?['channelThumbnailWithLinkRenderer']?['thumbnail']
              ?['thumbnails']),
      description:
          _extractText(item['detailedMetadataSnippets']?[0]?['snippetText']),
      channelUrl: item['longBylineText']?['runs']?[0]?['navigationEndpoint']
              ?['commandMetadata']?['webCommandMetadata']?['url']
          ?.toString()
          .substring(1),
      thumbnails: getThumbnails(item['thumbnail']?['thumbnails']),
    );
  }

  static Video _extractGridVideo(Map item) {
    return Video(
      videoId: item['videoId'],
      title: _extractText(item['title']),
      viewCount: _extractText(item['shortViewCountText']),
      duration: _extractText(item['thumbnailOverlays']?[0]
          ?['thumbnailOverlayTimeStatusRenderer']?['text']),
      publishedTime: _extractText(item['publishedTimeText']),
      channelName: _extractText(item['shortBylineText']),
      channelThumbnails: null,
      description:
          _extractText(item['detailedMetadataSnippets']?[0]?['snippetText']),
      channelUrl: item['shortBylineText']?['runs']?[0]?['navigationEndpoint']
              ?['commandMetadata']?['webCommandMetadata']?['url']
          ?.toString()
          .substring(1),
      thumbnails: getThumbnails(item['thumbnail']?['thumbnails']),
    );
  }

  static Video _extractPlaylistVideo(item) {
    return Video(
      videoId: item['videoId'],
      title: _extractText(item['title']),
      viewCount: _extractText(item['videoInfo']?['runs']?[0]),
      duration: _extractText(item['lengthText']),
      publishedTime: _extractText(item['videoInfo']?['runs']?[2]),
      thumbnails: getThumbnails(item['thumbnail']?['thumbnails']),
      channelName: null,
      channelThumbnails: null,
      description: null,
      channelUrl: null,
    );
  }

  static Related<dynamic> _extractRelated(Map<String, dynamic> item) {
    final relatedItems = item['content']?['verticalListRenderer']?['items'] ??
        item['content']?['horizontalListRenderer']?['items'];

    final String? title = _extractText(item['title']);
    final List<Video> videos = [];
    final List<Playlist> playlists = [];

    for (var relatedItem in relatedItems) {
      if (relatedItem['videoRenderer'] != null) {
        videos.add(_extractVideo(relatedItem['videoRenderer']));
      } else if (relatedItem['gridVideoRenderer'] != null) {
        videos.add(_extractGridVideo(relatedItem['gridVideoRenderer']));
      } else if (relatedItem['lockupViewModel'] != null) {
        playlists.add(_extractPlaylist(relatedItem['lockupViewModel']));
      }
    }

    return videos.isNotEmpty
        ? Related<Video>(title: title, relatedVideos: videos)
        : Related<Playlist>(title: title, relatedVideos: playlists);
  }

  static List<Thumbnail> getThumbnails(List? items) {
    return items
            ?.map((thumbnail) => Thumbnail(
                  url: thumbnail['url'],
                  width: thumbnail['width'],
                  height: thumbnail['height'],
                ))
            .toList() ??
        [];
  }

  static String? _extractText(dynamic item) {
    if (item == null) return null;

    if (item is Map) {
      if (item.containsKey('title') && item['title'] is Map) {
        return item['title']?['content'];
      }

      if (item['runs'] is List) {
        return (item['runs'] as List).map((run) => run['text']).join();
      }

      return item['simpleText'] ??
          item['content'] ??
          item['text'] ??
          item['title'];
    }

    return null;
  }
}
