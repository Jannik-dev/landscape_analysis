import 'package:args/command_runner.dart';

import 'gitlab_command.dart';
import 'local_command.dart';

class FetchCommand extends Command<void> {
  @override
  final String name = 'fetch';
  @override
  final String description = 'Fetch file.yaml files from various sources.';

  FetchCommand() {
    addSubcommand(LocalCommand());
    addSubcommand(GitLabCommand());
    // Add other subcommands as needed (e.g., GitHubCommand)
  }

  @override
  void run() {
    // The main logic is handled in the subcommands.
    printUsage();
  }
}
