import 'package:args/command_runner.dart';
import 'package:landscape_analysis/core/output/gexf_generator.dart';

import '../../core/output/dot_generator.dart';
import '../../core/output/graph_ml_generator.dart';
import '../../core/output/output_generator.dart';
import '../../core/output/json_generator.dart';
import '../../core/processing/dependency_edge.dart';
import '../../core/processing/dependency_graph_parser.dart';
import '../../core/processing/dependency_node.dart';
import '../../core/processing/graph/graph.dart';
import '../../core/processing/pubspec_loader.dart';

class AnalyzeCommand extends Command<void> {
  AnalyzeCommand() {
    argParser.addOption(
      'format',
      abbr: 'f',
      defaultsTo: 'graphml',
      help: 'The output format',
      allowed: ['graphml', 'gexf', 'dot', 'json'],
    );
  }

  @override
  String get name => 'analyze';

  @override
  String get description =>
      'Parses a folder of pubspec files and outputs the dependency graph.';

  @override
  Future<void> run() async {
    final path = _getPath();
    final outputGenerator = getOutputGenerator();

    final pubspecFiles = PubspecLoader.loadPubspecFiles(path);

    Graph<DependencyNode, DependencyEdge> dependencyGraph;
    try {
      dependencyGraph = DependencyGraphParser.parse(pubspecFiles);
    } on Exception catch (e) {
      throw Exception('Error: Failed to parse dependencies. Details: $e');
    }

    final representation = outputGenerator.toRepresentation(dependencyGraph);
    print(representation);
  }

  OutputGenerator getOutputGenerator() {
    final format = argResults?['format'] as String;
    // Select the appropriate generator
    final OutputGenerator generator;
    switch (format) {
      case 'json':
        generator = JsonGenerator();
        break;
      case 'dot':
        generator = DotGenerator(
          graphName: 'Dependencies',
          generalStyling: 'node [style=filled];',
        );
        break;
      case 'gexf':
        generator = GexfGenerator();
        break;
      case 'graphml':
        generator = GraphMLGenerator();
        break;
      default:
        generator = JsonGenerator();
        break;
    }
    return generator;
  }

  Uri _getPath() {
    final positionalArgs = argResults?.rest;
    if (positionalArgs == null || positionalArgs.isEmpty) {
      throw Exception('Error: No folder path provided.');
    }

    final folderPath = positionalArgs.last;
    final Uri path;
    try {
      path = Uri.parse(folderPath);
    } catch (e) {
      throw Exception('Invalid path provided: $folderPath');
    }
    return path;
  }
}
