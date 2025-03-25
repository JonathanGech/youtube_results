import 'thumbnail.dart';

/// Represents a YouTube Shorts video with metadata such as title, video ID, and thumbnails.
/// - `String?` title;
/// - `String?` videoId;
/// - `String?` viewCount;
/// - `List<Thumbnail>?` thumbnails;
/// - `List<Thumbnail>?` channelThumbnails;
class Shorts {
  /// The title of the Shorts video.
  final String? title;

  /// Unique identifier for the Shorts video.
  final String? videoId;

  /// The views of the Shorts video.
  final String? viewCount;

  /// List of thumbnails representing the Shorts video.
  final List<Thumbnail>? thumbnails;

  /// List of thumbnails representing the channel that uploaded the Shorts video.
  final List<Thumbnail>? channelThumbnails;

  /// Constructor to initialize a [Shorts] object.
  Shorts({
    this.title,
    this.videoId,
    this.viewCount,
    this.thumbnails,
    this.channelThumbnails,
  });
}
