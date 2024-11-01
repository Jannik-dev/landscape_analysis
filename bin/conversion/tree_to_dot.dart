import 'tree.dart';

class TreeToDot<T> {
  final String graphName;
  final String generalStyling;
  final String Function(T node) getLabel;
  final String Function(T node) getStyle;

  TreeToDot({
    required this.graphName,
    required this.generalStyling,
    required this.getLabel,
    required this.getStyle,
  });

  String toDot(Tree<T> tree) {
    final nodeStatements = <String>{}; // Use a Set to avoid duplicate nodes
    final edgeStatements = <String>{}; // Use a Set to avoid duplicate edges
    final stack = List<Tree<T>>.from(
        tree.children); // Stack initialized with children of root

    // Iterative depth-first traversal using a stack
    while (stack.isNotEmpty) {
      final node = stack.removeLast();

      // Add the node's definition to ensure it's only added once
      nodeStatements.add('"${getLabel(node.value)}" ${getStyle(node.value)};');

      // Process each child
      for (final child in node.children) {
        // Add the edge from the current node to the child
        edgeStatements
            .add('"${getLabel(node.value)}" -> "${getLabel(child.value)}";');

        // Push child onto the stack to process its children later
        stack.add(child);
      }
    }

    // Combine the node and edge statements
    final nodes = nodeStatements.join(' ');
    final edges = edgeStatements.join(' ');
    return 'digraph $graphName {$generalStyling $nodes $edges}';
  }
}
