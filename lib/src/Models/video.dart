import 'thumbnail.dart';

/// Represents a YouTube video with metadata such as title, description, duration, and thumbnails and channel information.
/// `- String?`  videoId;
/// - `String?` title;
/// - `String?` description;
/// - `String?` duration;
/// - `String?` publishedTime;
/// - `String?` viewCount;
/// - `List<Thumbnail>?` thumbnails;
/// - `String?` channelName;
/// - `String?` channelUrl;
/// - `List<Thumbnail>?` channelThumbnails;
class Video {
  /// Unique identifier for the video.
  final String? videoId;

  /// The title of the video.
  final String? title;

  /// A brief description of the video.
  final String? description;

  /// The duration of the video (formatted as a string, e.g., "5:23").
  final String? duration;

  /// The time when the video was published (formatted as a string).
  final String? publishedTime;

  /// The total number of views the video has received.
  final String? viewCount;

  /// List of thumbnails representing the video.
  final List<Thumbnail>? thumbnails;

  /// The name of the channel that uploaded the video.
  final String? channelName;

  /// The URL of the channel that uploaded the video.
  final String? channelUrl;

  /// List of thumbnails representing the channel.
  final List<Thumbnail>? channelThumbnails;

  /// Constructor to initialize a [Video] object.
  Video({
    this.videoId,
    this.title,
    this.description,
    this.duration,
    this.publishedTime,
    this.viewCount,
    this.thumbnails,
    this.channelName,
    this.channelUrl,
    this.channelThumbnails,
  });
}
