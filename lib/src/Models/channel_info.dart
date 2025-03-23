import 'thumbnail.dart';

/// Represents YouTube channel metadata such as title, description, and thumbnails.
/// - `String?` title;
/// - `String?` url;
/// - `String?` subscriptionCount;
/// - `String?` videoCount;
/// - `String?` description;
/// - `List<Thumbnail>?` thumbnails;
/// - `List<Thumbnail>?` banner;
/// - `List<dynamic>?` items;
class ChannelInfo {
  /// The name of the channel.
  final String? title;

  /// The URL of the channel's main page.
  final String? url;

  /// The total number of subscribers for the channel.
  final String? subscriptionCount;

  /// The total number of videos uploaded by the channel.
  final String? videoCount;

  /// A brief description of the channel.
  final String? description;

  /// List of thumbnails representing the channel's images.
  final List<Thumbnail>? thumbnails;

  /// Banner images for the channel.
  final List<Thumbnail>? banner;

  /// List containing additional items such as [Video], [Shorts], [Playlist], and [Related].
  final List<dynamic>? items;

  /// Constructor for initializing ChannelInfo
  ChannelInfo({
    this.title,
    this.url,
    this.subscriptionCount,
    this.videoCount,
    this.description,
    this.thumbnails,
    this.banner,
    this.items,
  });
}
