class Dependency {
  final String name;
  final bool isInternal;

  Dependency({
    required this.name,
    required this.isInternal,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dependency &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}
