import 'dart:io';

import 'package:dio/dio.dart';

import 'http/api_client.dart';
import 'pubspec_source.dart';

class GitlabSource implements PubspecSource {
  final String groupId;
  final Dio dio;

  /// Creates a new instance of [GitlabSource].
  ///
  /// - [groupId]: The ID or URL-encoded path of the group.
  /// - [token]: Your GitLab private token.
  /// - [apiUrl]: The base URL of the GitLab API (e.g., 'https://gitlab.com/api/v4').
  /// - [apiClient]: An instance of [ApiClient]. If not provided, a new one will be created.
  GitlabSource({
    required this.groupId,
    required String token,
    required String apiUrl,
    required ApiClient apiClient,
  }) : dio = apiClient.dio {
    dio.options.baseUrl = apiUrl;
    dio.options.headers['PRIVATE-TOKEN'] = token;
  }

  /// Fetches URIs of all `file.yaml` files available in the GitLab group.
  @override
  Future<List<Uri>> fetchPubspecUris() async {
    final List<Uri> pubspecUris = [];
    List<String> erroredProjects = [];

    print('Fetching projects from group $groupId...');
    await _loopOverPages(
      (page) async {
        print('Processing page $page of projects...');
        return await dio.get<List<dynamic>>(
          '/groups/$groupId/projects',
          queryParameters: {
            'include_subgroups': true,
            'per_page': 100,
            'page': page,
          },
        );
      },
      (project) async {
        try {
          await processProject(project, pubspecUris, pubspecUris.length);
        } catch (e) {
          print('Error processing project: $e');
          erroredProjects.add(project['id'].toString());
        }
      },
    );

    // Write errored projects to a file
    File('errors.txt').writeAsStringSync(erroredProjects.join('\n'));
    return pubspecUris;
  }

  Future<void> processProject(
      project, List<Uri> pubspecUris, int processedProjects) async {
    final projectId = project['id'];
    print('    Fetching file.yaml for project $projectId...');

    await _loopOverPages(
      (page) async => await dio.get<List<dynamic>>(
        '/projects/$projectId/repository/tree',
        queryParameters: {
          'recursive': true,
          'per_page': 100,
          'page': page,
        },
      ),
      (item) async {
        if (item['type'] == 'blob' &&
            (item['path'] as String).endsWith('file.yaml')) {
          if ((item['path'] as String).endsWith('example/file.yaml')) {
            print(
                '        EXCLUDE found file.yaml in project $projectId at: ${item['path']}');
            return;
          }
          print(
              '        Found file.yaml in project $projectId at: ${item['path']}');
          final filePath = Uri.encodeComponent(item['path'] as String);
          final fileUri = Uri.parse(
            '${dio.options.baseUrl}/projects/$projectId/repository/files/$filePath/raw',
          );
          pubspecUris.add(fileUri);
        }
      },
    );
  }

  Future<void> _loopOverPages(
    Future<Response<List<dynamic>>> Function(int page) getCallback,
    Future<void> Function(dynamic item) processItem,
  ) async {
    int totalPages;
    int page = 1;

    do {
      final response = await getCallback(page);

      // Extract total pages
      totalPages = int.parse(response.headers['x-total-pages']!.first);
      final treeItems = response.data!;

      // Process the items in the current page
      for (final item in treeItems) {
        await processItem(item);
      }

      // Increment page for the next loop
      page++;
    } while (page <= totalPages);
  }

  /// Fetches the content of a `file.yaml` file given its URI.
  @override
  Future<String> fetchPubspecContent(Uri uri) async {
    try {
      final response = await dio.getUri(uri);
      if (response.statusCode == 200) {
        return response.data.toString();
      } else {
        throw Exception(
            'Failed to fetch pubspec content: ${response.statusCode} ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('Error fetching pubspec content: ${e.message}');
      rethrow;
    }
  }
}
