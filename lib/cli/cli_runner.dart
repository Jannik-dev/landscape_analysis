import 'dart:io';

import 'package:args/command_runner.dart';

class CliRunner<T> extends CommandRunner<T> {
  CliRunner(super.executableName, super.description);

  @override
  Future<T?> run(Iterable<String> args) async {
    try {
      return await super.run(args);
    } on Exception catch (e) {
      print('$e\n');
      print('Usage:\n${argParser.usage}');
      exit(1);
    }
  }
}
