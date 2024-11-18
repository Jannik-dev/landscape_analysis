import 'dart:io';

class PubspecFilesProvider {
  final Uri folder;

  PubspecFilesProvider(this.folder);

  Future<Iterable<String>> getPubspecFiles() async {
    final List<String> fileContents = []; // List to store file contents

    // Convert Uri to Directory
    final directory = Directory.fromUri(folder);

    // Check if the directory exists
    if (await directory.exists()) {
      // List all entities in the directory (files and subdirectories)
      await for (var entity in directory.list(recursive: true)) {
        if (entity is File) {
          // If it's a file, read its content and add to the list
          final content = await entity.readAsString();
          fileContents.add(content); // Add content to the list
        }
      }
    } else {
      print("Directory does not exist: $folder");
    }

    return fileContents; // Return the list of contents
  }
}
