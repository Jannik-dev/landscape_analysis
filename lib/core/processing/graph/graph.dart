import 'edge.dart';
import 'node.dart';

class Graph<N extends Node, E extends Edge> {
  final Map<String, N> nodes = {}; // Nodes keyed by their IDs
  final Map<String, Map<String, E>> edges =
      {}; // Adjacency list with edge metadata

  void ensureNodeExists(N node) {
    nodes.putIfAbsent(node.id, () => node);
    assert(
      nodes.containsKey(node.id),
      'The node with ID ${node.id} was not added to the graph.',
    );
  }

  // Add a directed edge with metadata
  void addEdge(E edge) {
    // Ensure the nodes exist in the graph
    if (!nodes.containsKey(edge.from.id) || !nodes.containsKey(edge.to.id)) {
      throw ArgumentError(
          'Both nodes of the edge must already exist in the graph.');
    }

    // Add the edge
    edges.putIfAbsent(edge.from.id, () => {});
    assert(
      !edges[edge.from.id]!.containsKey(edge.to.id),
      'An edge from ${edge.from.id} to ${edge.to.id} already exists.',
    );
    edges[edge.from.id]![edge.to.id] = edge;
    assert(
      edges[edge.from.id]!.containsKey(edge.to.id),
      'The edge from ${edge.from.id} to ${edge.to.id} was not added.',
    );
  }

  // Get all children of a node (returns an empty list if no children exist)
  List<N> getChildren(String id) {
    final childEdges = edges[id];
    if (childEdges == null) {
      return <N>[]; // Explicitly return empty List<Node<N>>
    }
    return childEdges.values
        .map((edge) => edge.to as N)
        .toList(); // Ensure type consistency
  }

  // Find root nodes (nodes with no incoming edges)
  List<N> findRoots() {
    final childNodes = edges.values.expand((edgeMap) => edgeMap.keys).toSet();
    return nodes.values.where((node) => !childNodes.contains(node.id)).toList();
  }
}
