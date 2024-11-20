import 'package:args/args.dart';
import 'package:landscape_analysis/cli/commands/fetch-command/base_fetch_command.dart';
import 'package:landscape_analysis/core/input/gitlab_source.dart';
import 'package:landscape_analysis/core/input/pubspec_source.dart';
import 'package:landscape_analysis/core/shared/api_client.dart';

class GitLabCommand extends BaseFetchCommand {
  @override
  final String name = 'gitlab';
  @override
  final String description = 'Fetch pubspec.yaml files from a GitLab group.';

  GitLabCommand() {
    argParser
      ..addOption(
        'group-id',
        abbr: 'g',
        help: 'GitLab group ID to fetch projects from.',
        mandatory: true,
      )
      ..addOption(
        'token',
        abbr: 't',
        help: 'GitLab private token.',
        mandatory: true,
      )
      ..addOption(
        'api-url',
        abbr: 'u',
        defaultsTo: 'https://gitlab.com/api/v4',
        help: 'Base URL of the GitLab API.',
      )
      ..addOption(
        'retries',
        abbr: 'r',
        defaultsTo: '3',
        help: 'Number of retries for failed requests.',
      )
      ..addOption(
        'timeout',
        defaultsTo: '1000',
        help: 'Timeout duration in milliseconds.',
      );
  }

  @override
  PubspecSource buildSource(ArgResults argResults) {
    final groupId = argResults['group-id'] as String;
    final token = argResults['token'] as String;
    final apiUrl = argResults['api-url'] as String;
    final retries = int.parse(argResults['retries'] as String);
    final timeout = int.parse(argResults['timeout'] as String);
    return GitlabSource(
      groupId: groupId,
      token: token,
      apiUrl: apiUrl,
      apiClient: ApiClient(
        retries: retries,
        delayBetweenRequests: Duration(milliseconds: timeout),
      ),
    );
  }
}
