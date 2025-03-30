import 'thumbnail.dart';

/// Represents specific video information extracted from YouTube.
/// - `String? title;`
/// - `String? likes;`
/// - `String? viewCount;`
/// - `String? publishedTime;`
/// - `String? description;`
/// - `String? channelName;`
/// - `String? channelId;`
/// - `String? channelUrl;`
/// - `String? subscriptionCount;`
/// - `List<Thumbnail>? videoThumbnails;`
/// - `List<Thumbnail>? channelThumbnails;`
class VideoInfo {
  /// The title of the video.
  final String? title;

  /// The total number of likes the video has received.
  final String? likes;

  /// The total number of views the video has received.
  final String? viewCount;

  /// The time when the video was published (formatted as a string).
  final String? publishedTime;

  /// Description of the video.
  final String? description;

  /// The name of the channel that uploaded the video.
  final String? channelName;

  /// The unique ID of the channel.
  final String? channelId;

  /// The URL of the channel that uploaded the video.
  final String? url;

  /// The total number of subscribers for the channel.
  final String? subscriptionCount;

  /// List of thumbnails representing the channel.
  final List<Thumbnail>? channelThumbnails;

  /// A list of related video items.
  final List<dynamic>? items;

  /// Creates a [VideoInfo] instance.
  VideoInfo({
    this.title,
    this.description,
    this.publishedTime,
    this.viewCount,
    this.likes,
    this.channelName,
    this.channelId,
    this.url,
    this.subscriptionCount,
    this.channelThumbnails,
    this.items,
  });
}
