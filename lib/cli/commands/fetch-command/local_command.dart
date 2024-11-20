import 'dart:io';

import 'package:args/args.dart';
import 'package:landscape_analysis/core/input/local_source.dart';
import 'package:landscape_analysis/core/input/pubspec_source.dart';

import 'base_fetch_command.dart';

class LocalCommand extends BaseFetchCommand {
  @override
  final String name = 'local';
  @override
  final String description = 'Fetch file.yaml files from a local directory.';

  LocalCommand() {
    argParser.addOption(
      'input-dir',
      abbr: 'i',
      help: 'Input directory containing local projects.',
      mandatory: true,
    );
  }

  @override
  PubspecSource buildSource(ArgResults argResults) {
    final inputDir = Directory(argResults['input-dir']);
    return LocalSource(inputDir);
  }
}
