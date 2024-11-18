import 'package:args/command_runner.dart';
import 'package:pubspec_parse/pubspec_parse.dart' show Pubspec;

import '../dependency.dart';
import '../pubspec_files_provider.dart';
import '../pubspec_files_to_dependency_tree.dart';
import '../tree_to_dot.dart';

class ToDotCommand extends Command {
  ToDotCommand() {
    argParser.addOption(
      'path',
      abbr: 'p',
      help: 'Path to the folder containing pubspec files.',
      mandatory: true,
    );
    argParser.addOption(
      'generalStyling',
      abbr: 's',
      defaultsTo: 'node [style=filled];',
      help: 'The general styling to include in the dot diagram',
    );
  }

  @override
  String get name => 'folder';

  @override
  String get description =>
      '''Generates a dot diagram from a folder of pubspec files.

Dot diagrams can be interpreted by graphviz. You can install it from https://graphviz.org/download/.
To generate a diagram in one command you can use:
   landscape_analysis todot folder [arguments] | dot -Tsvg output.svg''';

  @override
  void run() async {
    final generalStyling = argResults?['generalStyling'] as String;

    final pubSpecFilesProvider = await _createPubspecFilesProvider();
    final rawPubspecFiles = await pubSpecFilesProvider.getPubspecFiles();
    final pubspecFiles = rawPubspecFiles.map((yaml) => Pubspec.parse(yaml));
    final dependencyTree = PubspecFilesToDependencyTree.parse(pubspecFiles);

    final dotString = TreeToDot<Dependency>(
      graphName: 'Dependencies',
      generalStyling: generalStyling,
      getLabel: (node) => node.name,
      getStyle: (node) => node.isInternal ? '[fillcolor=lightblue]' : '',
    ).toDot(dependencyTree);
    print(dotString);
  }

  Future<PubspecFilesProvider> _createPubspecFilesProvider() async {
    final path = argResults?['path'] as String;
    return PubspecFilesProvider(Uri.parse(path));
  }
}
