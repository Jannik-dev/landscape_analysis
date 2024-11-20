abstract class PubspecSource {
  /// Fetches URIs of all `file.yaml` files available in the source.
  Future<List<Uri>> fetchPubspecUris();

  /// Fetches the content of a `file.yaml` file given its URI.
  Future<String> fetchPubspecContent(Uri uri);
}
