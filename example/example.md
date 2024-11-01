You can analyse a folder with the following command:

```bash
landscape_analysis todot file --path ./path/to/your/folder
```

...or analyse a gitlab group like so:

```bash
landscape_analysis todot gitlab --token YOUR_TOKEN --groupId YOUR_GROUP_ID --gitlabApiUrl YOUR_GITLAB_URL
```

You can also pipe the output to dot like so:

```bash
landscape_analysis todot file --path ./pubs | dot -Tsvg -o output.svg
```