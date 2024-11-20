import 'dart:convert';

import '../processing/dependency_edge.dart';
import '../processing/dependency_node.dart';
import '../processing/graph/graph.dart';
import 'output_generator.dart';

class JsonGenerator implements OutputGenerator {
  @override
  String toRepresentation(Graph<DependencyNode, DependencyEdge> graph) {
    final nodes = graph.nodes.values.map((node) {
      return {
        'id': node.id,
        'isInternal': node.isInternal,
      };
    }).toList();

    final edges = graph.edges.values.expand((edgeMap) {
      return edgeMap.values.map((edge) {
        return {
          'from': edge.from.id,
          'to': edge.to.id,
        };
      });
    }).toList();

    final graphRepresentation = {
      'nodes': nodes,
      'edges': edges,
    };

    return jsonEncode(graphRepresentation);
  }
}
