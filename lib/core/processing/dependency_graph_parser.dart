import 'package:landscape_analysis/core/processing/graph/graph.dart';
import 'package:pubspec_parse/pubspec_parse.dart';

import 'dependency_edge.dart';
import 'dependency_node.dart';

class DependencyGraphParser {
  DependencyGraphParser._();

  static Graph<DependencyNode, DependencyEdge> parse(
      Iterable<Pubspec> pubspecs) {
    final graph = Graph<DependencyNode, DependencyEdge>();

    for (final pubspec in pubspecs) {
      // Check if the node already exists and update its isInternal flag
      final existingNode = graph.nodes[pubspec.name];
      final pubspecNode =
          existingNode ?? DependencyNode(pubspec.name, isInternal: true);

      if (existingNode != null) {
        existingNode.isInternal =
            true; // Update isInternal if the node already exists
      } else {
        graph.ensureNodeExists(pubspecNode);
      }

      // Add dependencies for the current pubspec
      for (final entry in pubspec.dependencies.entries) {
        final dependencyName = entry.key;

        // Add or find the dependency node
        final dependencyNode = graph.nodes[dependencyName] ??
            DependencyNode(dependencyName, isInternal: false);

        if (!graph.nodes.containsKey(dependencyName)) {
          graph.ensureNodeExists(dependencyNode);
        }

        // Create an edge between the pubspec and its dependency
        final edge = DependencyEdge(pubspecNode, dependencyNode);
        graph.addEdge(edge);
      }
    }

    return graph;
  }
}
