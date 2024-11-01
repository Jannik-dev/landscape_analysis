import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'pubspec_files_provider.dart';

class GitlabPubspecsProvider extends PubspecFilesProvider {
  final Uri gitlabApiUrl;
  final String groupId;
  final String token;
  final int maxRetries;
  final Duration delayBetweenRequests;

  GitlabPubspecsProvider({
    required this.gitlabApiUrl,
    required this.groupId,
    required this.token,
    this.maxRetries = 3,
    this.delayBetweenRequests = const Duration(milliseconds: 500),
  });

  @override
  Future<Iterable<String>> getPubspecFiles() async {
    final projectIds = await getProjectIdsInGroup(groupId);
    final pubspecs = <String>[];

    for (final projectId in projectIds) {
      final pubspecPaths = await getAllPubspecPaths(projectId);

      for (final path in pubspecPaths) {
        final content = await retryWithDelay(
              () => getPubspecContent(projectId, path),
          maxRetries,
          delayBetweenRequests,
        );
        if (content.isNotEmpty) {
          pubspecs.add(content);
        }
        await Future.delayed(delayBetweenRequests); // Rate limit between requests
      }
    }

    return pubspecs;
  }

  Future<List<String>> getProjectIdsInGroup(String groupId) async {
    final url = Uri.parse('$gitlabApiUrl/groups/$groupId/projects');
    final headers = {'Private-Token': token};
    final response = await retryWithDelay(() => http.get(url, headers: headers), maxRetries, delayBetweenRequests);

    if (response.statusCode == 200) {
      final projects = jsonDecode(response.body) as List;
      return projects.map((project) => project['id'].toString()).toList();
    } else {
      throw Exception('Failed to load project IDs');
    }
  }

  Future<List<String>> getAllPubspecPaths(String projectId) async {
    final url = Uri.parse('$gitlabApiUrl/projects/$projectId/repository/tree');
    final headers = {'Private-Token': token};
    final pubspecPaths = <String>[];
    int page = 1;
    bool hasMore = true;

    while (hasMore) {
      final response = await retryWithDelay(
            () => http.get(
          url.replace(queryParameters: {'recursive': 'true', 'page': page.toString()}),
          headers: headers,
        ),
        maxRetries,
        delayBetweenRequests,
      );

      if (response.statusCode == 200) {
        final files = jsonDecode(response.body) as List;
        for (final file in files) {
          if (file['type'] == 'blob' && file['path'].endsWith('pubspec.yaml')) {
            pubspecPaths.add(file['path']);
          }
        }
        hasMore = files.isNotEmpty;
        page++;
        await Future.delayed(delayBetweenRequests); // Delay between paginated requests
      } else {
        throw Exception('Failed to retrieve file paths for project $projectId');
      }
    }

    return pubspecPaths;
  }

  Future<String> getPubspecContent(String projectId, String filePath) async {
    final url = Uri.parse('$gitlabApiUrl/projects/$projectId/repository/files/$filePath/raw');
    final response = await http.get(url, headers: {'Private-Token': token});

    if (response.statusCode == 200) {
      return response.body;
    } else if (response.statusCode == 404) {
      print('File not found: $filePath in project $projectId');
      return '';
    } else {
      throw Exception('Failed to retrieve content for $filePath');
    }
  }

  // Helper function for retrying with delay
  Future<T> retryWithDelay<T>(Future<T> Function() action, int retries, Duration delay) async {
    for (int attempt = 0; attempt < retries; attempt++) {
      try {
        return await action();
      } catch (e) {
        if (attempt == retries - 1) {
          rethrow; // Rethrow after final attempt
        }
        await Future.delayed(delay);
      }
    }
    throw Exception('Failed after $retries attempts');
  }
}
