/// Represents a thumbnail image with its URL and dimensions.
/// - `String?` url;
/// - `int?` width;
/// - `int?` height;
class Thumbnail {
  /// The URL of the thumbnail image.
  final String? url;

  /// The width of the thumbnail image in pixels.
  final int? width;

  /// The height of the thumbnail image in pixels.
  final int? height;

  /// Constructor to initialize a [Thumbnail] object.
  Thumbnail({
    this.url,
    this.width,
    this.height,
  });
}
