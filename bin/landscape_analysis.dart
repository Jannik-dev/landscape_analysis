import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:landscape_analysis/cli/cli_runner.dart';
import 'package:landscape_analysis/cli/commands/analyze_command.dart';
import 'package:landscape_analysis/cli/commands/fetch-command/fetch_command.dart';
import 'package:yaml/yaml.dart';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    );
}

String getVersion() {
  final pubspecFile = File('file.yaml');

  if (!pubspecFile.existsSync()) {
    print('file.yaml not found');
    exit(1);
  }

  final content = pubspecFile.readAsStringSync();
  final yamlMap = loadYaml(content);

  if (yamlMap.containsKey('version')) {
    return yamlMap['version'];
  } else {
    print('No version in file.yaml found');
    exit(1);
  }
}

void main(List<String> arguments) async {
  // Initialize the CommandRunner and add ToDotCommand
  final CommandRunner<void> runner = CliRunner<void>(
      'landscape_analysis', 'A tool for generating dependency diagrams')
    ..addCommand(FetchCommand())
    ..addCommand(AnalyzeCommand())
    ..argParser.addFlag(
      'version',
      abbr: 'v',
      negatable: false,
      help: 'Print the tool version.',
    );

  // Check for the version flag before running the command runner
  final argResults = runner.argParser.parse(arguments);

  if (argResults['version'] == true) {
    print(getVersion());
    return;
  }

  // Run the command runner and handle errors
  try {
    await runner.run(arguments);
  } on FormatException catch (e) {
    print(e.message);
    print('');
    runner.printUsage();
  } catch (e) {
    print('Error: $e');
  }
}
