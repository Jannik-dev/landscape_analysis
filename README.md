# Landscape Analysis CLI

`landscape_analysis` is a Dart CLI tool for analyzing Dart package dependencies and generating visual dependency graphs using Graphviz. It reads `pubspec.yaml` files, builds a dependency tree, and outputs a Graphviz-compatible dot format for visualization.

## Features

- Analyze dependencies from a folder of Dart `pubspec.yaml` files.
- Fetch dependencies from a GitLab group using API credentials.
- Output dependency graphs in Graphviz dot format.

## Prerequisites

1. **Dart SDK**: Install the [Dart SDK](https://dart.dev/get-dart).
2. **Graphviz**: Install [Graphviz](https://graphviz.org/download/) for visualizing diagrams. Ensure `dot` is available in your PATH.

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
   dart compile exe bin/main.dart -o landscape_analysis
   ```

3. Run the executable:

   ```bash
   ./landscape_analysis <command> <options>
   ```

## Usage

You can analyse a folder with the following command:

```bash
landscape_analysis todot file --path ./path/to/your/folder
```

...or analyse a gitlab group like so:

```bash
landscape_analysis todot gitlab --token YOUR_TOKEN --groupId YOUR_GROUP_ID --gitlabApiUrl YOUR_GITLAB_URL
```

### Generate Graphs with Graphviz

To visualize the dependency graph with Graphviz, pipe the output to `dot`.
For more information about Graphviz visit https://graphviz.org.

```bash
landscape_analysis todot file --path ./pubs | dot -Tsvg -o output.svg
```

## Troubleshooting

- **`dot` command not found**: Ensure Graphviz is installed and its `bin` directory is in your PATH.
- **GitLab API permissions**: Ensure your API token has the necessary access.

## Contributing

Contributions are welcome! Open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

