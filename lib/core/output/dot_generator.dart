import '../processing/dependency_edge.dart';
import '../processing/dependency_node.dart';
import '../processing/graph/graph.dart';
import 'output_generator.dart';

class DotGenerator implements OutputGenerator {
  final String graphName;
  final String generalStyling;

  DotGenerator({
    required this.graphName,
    required this.generalStyling,
  });

  @override
  String toRepresentation(Graph<DependencyNode, DependencyEdge> graph) {
    final buffer = StringBuffer();

    // Start the graph representation
    buffer.writeln('digraph $graphName {$generalStyling');

    // Iterate over nodes
    for (final node in graph.nodes.values) {
      buffer.writeln(
        '  "${node.id}" ${node.isInternal ? '[fillcolor=lightblue]' : ''};',
      );
    }

    // Iterate over edges
    for (final edgeMap in graph.edges.values) {
      for (final edge in edgeMap.values) {
        buffer.writeln('  "${edge.from.id}" -> "${edge.to.id}";');
      }
    }

    // End the graph representation
    buffer.writeln('}');

    return buffer.toString();
  }
}
