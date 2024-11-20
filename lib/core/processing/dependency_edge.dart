import 'dependency_node.dart';
import 'graph/edge.dart';

class DependencyEdge extends Edge<DependencyNode> {
  DependencyEdge(super.from, super.to);
}
