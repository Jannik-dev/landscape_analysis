import 'dart:io';
import 'package:pubspec_parse/pubspec_parse.dart';

class PubspecLoader {
  static Iterable<Pubspec> loadPubspecFiles(Uri directoryUri) {
    final directory = Directory.fromUri(directoryUri);

    if (!directory.existsSync()) {
      throw Exception('Directory does not exist: $directoryUri');
    }

    final files = directory.listSync().whereType<File>();
    final pubspecFiles = files.where(
        (file) => file.path.endsWith('.yaml') || file.path.endsWith('.yml'));

    if (pubspecFiles.isEmpty) {
      throw Exception('No pubspec.yaml files found in $directoryUri');
    }

    return pubspecFiles.map((file) {
      final content = file.readAsStringSync();
      try {
        return Pubspec.parse(content);
      } on Exception catch (e) {
        throw Exception('Failed to parse pubspec file: ${file.path}\n$e');
      }
    });
  }
}
