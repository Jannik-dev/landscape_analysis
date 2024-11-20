import 'graph/node.dart';

class DependencyNode extends Node {
  bool isInternal;

  DependencyNode(super.id, {required this.isInternal});
}
