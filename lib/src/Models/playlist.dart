import 'thumbnail.dart';

//// Represents a YouTube playlist with metadata such as title, channel name, and thumbnails.
/// - `String?` title;
/// - `String?` videoCount;
/// - `String?` playListId;
/// - `String?` channelName;
/// - `String?` channelUrl;
/// - `List<Thumbnail>?` thumbnails;
class Playlist {
  /// The title of the playlist.
  final String? title;

  /// Overlay text, usually displaying additional playlist information.
  final String? videoCount;

  /// Unique identifier for the YouTube playlist.
  final String? playListId;

  /// The name of the channel.
  final String? channelName;

  /// Url of the channel
  final String? channelUrl;

  /// List of thumbnails representing the playlist.
  final List<Thumbnail>? thumbnails;

  /// Constructor to initialize a [Playlist] object.
  Playlist({
    this.title,
    this.videoCount,
    this.playListId,
    this.channelName,
    this.channelUrl,
    this.thumbnails,
  });
}
