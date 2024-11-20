import '../processing/dependency_edge.dart';
import '../processing/dependency_node.dart';
import '../processing/graph/graph.dart';
import 'output_generator.dart';

class GraphMLGenerator implements OutputGenerator {
  @override
  String toRepresentation(Graph<DependencyNode, DependencyEdge> graph) {
    final buffer = StringBuffer();

    // Write GraphML header
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<graphml xmlns="http://graphml.graphdrawing.org/xmlns" '
        'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
        'xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns '
        'http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">');
    buffer.writeln('<graph edgedefault="directed">');

    // Add node attributes (e.g., isInternal)
    buffer.writeln(
        '<key id="isInternal" for="node" attr.name="isInternal" attr.type="boolean"/>');

    // Add nodes
    for (final node in graph.nodes.values) {
      buffer.writeln('<node id="${node.id}">');
      buffer.writeln('  <data key="isInternal">${node.isInternal}</data>');
      buffer.writeln('</node>');
    }

    // Add edges
    for (final edgeMap in graph.edges.values) {
      for (final edge in edgeMap.values) {
        buffer
            .writeln('<edge source="${edge.from.id}" target="${edge.to.id}"/>');
      }
    }

    // Close GraphML tags
    buffer.writeln('</graph>');
    buffer.writeln('</graphml>');

    return buffer.toString();
  }
}
