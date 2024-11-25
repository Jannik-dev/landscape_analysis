Put the `pubspec.yaml` files in a folder and run the following command to analyze them:

```bash
landscape_analysis analyze --format <format> ./path/to/your/folder > output
```

Optional: You can fetch `pubspec.yaml` files from a gitlab group using:

```bash
landscape_analysis fetch gitlab --token <token> --group-id <group-id> --api-url <api-url>
```