import 'thumbnail.dart';

/// Represents YouTube playlist metadata such as title, description, and thumbnails.
/// - `String?` title;
/// - `String?` url;
/// - `String?` channelName;
/// - `String?` videoCount;
/// - `String?` viewCount;
/// - `String?` description;
/// - `List<Thumbnail>?` thumbnails;
/// - `List<Thumbnail>?` channelThumbnails;
/// - `List<dynamic>?` items;
class PlaylistInfo {
  /// The name of the playlist.
  final String? title;

  /// The URL of the channel's main page.
  final String? url;

  /// Channel name.
  final String? channelName;

  /// The total number of videos in the playlist.
  final String? videoCount;

  /// The total number of views in the playlist.
  final String? viewCount;

  /// A brief description of the playlist.
  final String? description;

  /// List of thumbnails representing the playlist's images.
  final List<Thumbnail>? thumbnails;

  /// List of thumbnails representing the channel that uploaded the playlist.
  final List<Thumbnail>? channelThumbnails;

  /// List containing additional items such as [Related], [Video], and [Shorts].
  final List<dynamic>? items;

  /// Constructor for initializing PlaylistInfo.
  PlaylistInfo({
    this.title,
    this.url,
    this.channelName,
    this.videoCount,
    this.viewCount,
    this.description,
    this.thumbnails,
    this.channelThumbnails,
    this.items,
  });
}