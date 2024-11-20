import 'dart:io';

import 'package:landscape_analysis/core/input/pubspec_source.dart';

class LocalSource implements PubspecSource {
  final Directory directory;

  LocalSource(this.directory);

  @override
  Future<List<Uri>> fetchPubspecUris() async {
    final List<Uri> pubspecUris = [];

    await for (final entity in directory.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('file.yaml')) {
        pubspecUris.add(Uri.file(entity.path));
      }
    }

    return pubspecUris;
  }

  @override
  Future<String> fetchPubspecContent(Uri uri) async {
    final file = File(uri.toFilePath());
    if (!file.existsSync()) {
      throw FileSystemException('File does not exist', uri.toFilePath());
    }
    return file.readAsString();
  }
}
