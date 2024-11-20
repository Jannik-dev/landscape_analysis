import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:landscape_analysis/core/input/pubspec_source.dart';
import 'package:meta/meta.dart';

abstract class BaseFetchCommand extends Command<void> {
  @override
  Future<void> run() async {
    final PubspecSource source = buildSource(argResults!);
    if (argResults!.rest.isEmpty) {
      throw ArgumentError('No output directory provided.');
    }
    final String outputDir = argResults!.rest.last;
    print('Fetching pubspec files to "$outputDir"');

    final uris = await source.fetchPubspecUris();
    print('Found ${uris.length} pubspec files');
    print('Downloading pubspec files to $outputDir');
    for (final uri in uris) {
      final file = File('$outputDir/${uri.toString().hashCode}.yaml');
      if (!file.existsSync()) {
        final content = await source.fetchPubspecContent(uri);
        file.writeAsStringSync(content);
      }
    }
    print('Downloaded ${uris.length} pubspec files to $outputDir');
  }

  @override
  String get invocation {
    return 'landscape_analysis $name [arguments] <output-dir>';
  }

  @protected
  PubspecSource buildSource(ArgResults argResults);
}
