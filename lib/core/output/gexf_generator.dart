import '../processing/dependency_edge.dart';
import '../processing/dependency_node.dart';
import '../processing/graph/graph.dart';
import 'output_generator.dart';

class GexfGenerator implements OutputGenerator {
  @override
  String toRepresentation(Graph<DependencyNode, DependencyEdge> graph) {
    final buffer = StringBuffer();

    // Start GEXF header
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<gexf xmlns="http://www.gexf.net/1.2draft" version="1.2">');
    buffer.writeln('<graph mode="static" defaultedgetype="directed">');
    buffer.writeln('<attributes class="node" mode="static">');
    buffer.writeln(
        '<attribute id="isInternal" title="isInternal" type="boolean" />');
    buffer.writeln('</attributes>');

    // Add nodes
    buffer.writeln('<nodes>');
    for (final node in graph.nodes.values) {
      buffer.writeln(
        '  <node id="${node.id}" label="${node.id}">'
        '<attvalues>'
        '<attvalue for="isInternal" value="${node.isInternal}" />'
        '</attvalues>'
        '</node>',
      );
    }
    buffer.writeln('</nodes>');

    // Add edges
    buffer.writeln('<edges>');
    int edgeId = 0;
    for (final edgeMap in graph.edges.values) {
      for (final edge in edgeMap.values) {
        buffer.writeln(
          '  <edge id="$edgeId" source="${edge.from.id}" target="${edge.to.id}" />',
        );
        edgeId++;
      }
    }
    buffer.writeln('</edges>');

    // Close GEXF
    buffer.writeln('</graph>');
    buffer.writeln('</gexf>');

    return buffer.toString();
  }
}
