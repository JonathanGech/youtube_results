import 'thumbnail.dart';

/// Represents a YouTube channel with metadata such as title, description, and thumbnails.
/// - `String?` channelId;
/// - `String?` title;
/// - `List<Thumbnail>?` thumbnails;
/// - `String?` description;
/// - `String?` subscriptionCount;
/// - `String?` channelUrl;
class Channel {
  /// Unique identifier for the channel.
  final String? channelId;

  /// The name of the channel.
  final String? title;

  /// List of thumbnails representing the channel's images.
  final List<Thumbnail>? thumbnails;

  /// A brief description of the channel.
  final String? description;

  /// The total number of videos uploaded by the channel.
  final String? subscriptionCount;

  /// The URL of the channel's main page.
  final String? channelUrl;

  /// Constructor to initialize a [Channel] object.
  Channel({
    this.channelId,
    this.title,
    this.thumbnails,
    this.description,
    this.subscriptionCount,
    this.channelUrl,
  });
}
