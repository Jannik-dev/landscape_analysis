import '../processing/dependency_edge.dart';
import '../processing/dependency_node.dart';
import '../processing/graph/graph.dart';

abstract class OutputGenerator {
  String toRepresentation(Graph<DependencyNode, DependencyEdge> graph);
}
