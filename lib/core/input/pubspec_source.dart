abstract class PubspecSource {
  /// Fetches URIs of all `pubspec.yaml` files available in the source.
  Future<List<Uri>> fetchPubspecUris();

  /// Fetches the content of a `pubspec.yaml` file given its URI.
  Future<String> fetchPubspecContent(Uri uri);
}
