import 'package:args/command_runner.dart';
import 'package:pubspec_parse/pubspec_parse.dart' show Pubspec;

import '../conversion/dependency.dart';
import '../conversion/pubspec_files_to_dependency_tree.dart';
import '../conversion/tree_to_dot.dart';
import '../pubspec_files_provider/pubspec_files_provider.dart';

abstract class BaseToDotCommand extends Command {
  BaseToDotCommand() {
    argParser.addOption(
      'generalStyling',
      defaultsTo: 'node [style=filled];',
      help: 'The general styling to include in the dot diagram',
    );
  }

  /// This method should be implemented in the subclasses to provide
  /// the appropriate `PubspecFilesProvider`.
  Future<PubspecFilesProvider> createPubspecFilesProvider();

  @override
  void run() async {
    final generalStyling = argResults?['generalStyling'] as String;

    final pubSpecFilesProvider = await createPubspecFilesProvider();
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
}
