# Landscape Analysis CLI

`landscape_analysis` is a Dart CLI tool for analyzing Dart package dependencies and generating visual dependency graphs. It reads `pubspec.yaml` files, builds a dependency tree, and supports different output formats.

## Features

- Fetch dependencies from a GitLab group using API credentials.
- Analyze dependencies from a folder of Dart `pubspec.yaml` files.
- Output dependency graphs in dot, gexf, graphml or json format.

## Prerequisites

1. **Dart SDK**: Install the [Dart SDK](https://dart.dev/get-dart).

## Installation

### Option 1: Install with `dart pub activate`

Activate `landscape_analysis` directly from `pub.dev` or a Git repository.

- **From `pub.dev`**:

  ```bash
  dart pub activate landscape_analysis
  ```


### Option 2: Compile a Standalone Executable

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/landscape_analysis.git
   cd landscape_analysis
   ```

2. Compile the executable:

   ```bash
   dart compile exe bin/landscape_analysis.dart -o landscape_analysis
   ```

3. Run the executable:

   ```bash
   ./landscape_analysis <command> <options>
   ```

## Usage

Put the `pubspec.yaml` files in a folder and run the following command to analyze them:

```bash
landscape_analysis analyze --format <format> ./path/to/your/folder > output
```

Optional: You can fetch `pubspec.yaml` files from a gitlab group using:

```bash
landscape_analysis fetch gitlab --token <token> --group-id <group-id> --api-url <api-url>
```

### Visualize the graph

It is recommended to use yEd (uses graphml-format) for visualization, if a hierarchical structure is desired.
For simple graphs GraphViz (uses dot-format) is sufficient.
And some metrics can be calculated in Gephi (uses gexf-format).

## Contributing

Contributions are welcome! Open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

