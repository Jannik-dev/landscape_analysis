import '../pubspec_files_provider/folder_pubspec_files_provider.dart';
import '../pubspec_files_provider/pubspec_files_provider.dart';
import 'base_to_dot_command.dart';

class FromFolderCommand extends BaseToDotCommand {
  @override
  String get name => 'folder';

  @override
  String get description =>
      '''Generates a dot diagram from a folder of pubspec files.

Dot diagrams can be interpreted by graphviz. You can install it from https://graphviz.org/download/.
To generate a diagram in one command you can use:
   landscape_analysis todot folder [arguments] | dot -Tsvg output.svg''';

  FromFolderCommand() {
    argParser.addOption(
      'path',
      abbr: 'p',
      help: 'Path to the folder containing pubspec files.',
      mandatory: true,
    );
  }

  @override
  Future<PubspecFilesProvider> createPubspecFilesProvider() async {
    final path = argResults?['path'] as String;
    return FolderPubspecFilesProvider(Uri.parse(path));
  }
}
