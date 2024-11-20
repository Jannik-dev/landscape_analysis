import 'package:meta/meta.dart';

import 'node.dart';

@immutable
class Edge<N extends Node> {
  final N from;
  final N to;

  Edge(this.from, this.to);
}
