import '../pubspec_files_provider/gitlab_pubspec_files_provider.dart';
import '../pubspec_files_provider/pubspec_files_provider.dart';
import 'base_to_dot_command.dart';

class FromGitlabCommand extends BaseToDotCommand {
  @override
  String get name => 'gitlab';
  @override
  String get description =>
      '''Generates a dot diagram from a GitLab group by searching for pubspec files.

Dot diagrams can be interpreted by graphviz. You can install it from https://graphviz.org/download/.
To generate a diagram in one command you can use:
   landscape_analysis todot gitlab [arguments] | dot -Tsvg output.svg''';

  FromGitlabCommand() {
    argParser
      ..addOption(
        'token',
        abbr: 't',
        help: 'GitLab token (required)',
        mandatory: true,
      )
      ..addOption(
        'groupId',
        abbr: 'g',
        help: 'The GitLab group ID to search (required)',
        mandatory: true,
      )
      ..addOption(
        'gitlabApiUrl',
        abbr: 'u',
        help: 'GitLab API URL (required)',
        mandatory: true,
      );
  }

  @override
  Future<PubspecFilesProvider> createPubspecFilesProvider() async {
    final token = argResults?['token'] as String;
    final groupId = argResults?['groupId'] as String;
    final gitlabApiUrl = argResults?['gitlabApiUrl'] as String;
    return GitlabPubspecsProvider(
      gitlabApiUrl: Uri.parse(gitlabApiUrl),
      groupId: groupId,
      token: token,
    );
  }
}
