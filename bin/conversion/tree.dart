class Tree<T> {
  T value;
  Tree<T>? parent;
  List<Tree<T>> children = [];

  Tree(this.value);

  // Adds a child to this node
  void addChild(Tree<T> child) {
    child.parent = this;
    children.add(child);
  }

  // Traverses the tree in a depth-first manner
  void traverse(void Function(Tree<T> node) action) {
    action(this);
    for (var child in children) {
      child.traverse(action);
    }
  }

  Tree<T>? find(T searchValue) {
    Tree<T>? foundNode;
    traverse((node) {
      if (node.value == searchValue) {
        foundNode = node;
        return; // Early exit by setting foundNode
      }
    });
    return foundNode;
  }
}
