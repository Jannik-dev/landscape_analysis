import 'package:pubspec_parse/pubspec_parse.dart' show Pubspec;

import 'tree.dart';
import 'dependency.dart';

class PubspecFilesToDependencyTree {
  PubspecFilesToDependencyTree._();

  static Tree<Dependency> parse(Iterable<Pubspec> pubspecs) {
    final root = Tree<Dependency>(
      // add a temporary root node
      Dependency(name: 'temporary root node', isInternal: false),
    );
    for (final pubspec in pubspecs) {
      var pubspecNode = root.find(
        Dependency(name: pubspec.name, isInternal: true),
      );
      if (pubspecNode == null) {
        pubspecNode = Tree(
          Dependency(name: pubspec.name, isInternal: true),
        );
        root.addChild(pubspecNode);
      } else {
        // Set internal if node already exists
        pubspecNode.value =
            Dependency(name: pubspecNode.value.name, isInternal: true);
      }

      for (final dependency in pubspec.dependencies.keys) {
        final dependencyNode = root.find(
          Dependency(name: dependency, isInternal: false),
        );
        if (dependencyNode != null) {
          pubspecNode.addChild(dependencyNode);
        } else {
          pubspecNode.addChild(Tree(
            Dependency(name: dependency, isInternal: false),
          ));
        }
      }
    }
    return root;
  }
}
