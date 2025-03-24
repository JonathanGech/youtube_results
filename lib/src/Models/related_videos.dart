/// Represent Related videos it can be Shorts or Horizontally aligned videos
///  - `String?` title;
///  - `List<T>?` relatedVideos;
class Related<T> {
  /// Title
  final String? title;

  /// List of related videos.
  final List<T>? relatedVideos;

  /// Constructor to initialize a [RelatedVideos] object.
  Related({this.title, this.relatedVideos});
}
