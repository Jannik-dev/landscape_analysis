import 'package:args/command_runner.dart';

import 'from_folder_command.dart';
import 'from_gitlab_command.dart';

const gitlabOption = 'gitlab';
const folderOption = 'folder';

class ToDotCommand extends Command {
  @override
  String get name => 'todot';
  @override
  String get description => '''Generates a dot diagram for dependencies.

Dot diagrams can be interpreted by graphviz. You can install it from https://graphviz.org/download/.
To generate a diagram in one command you can use:
   landscape_analysis todot <subcommand> [arguments] | dot -Tsvg output.svg''';

  ToDotCommand() {
    addSubcommand(FromFolderCommand());
    addSubcommand(FromGitlabCommand());
  }
}
