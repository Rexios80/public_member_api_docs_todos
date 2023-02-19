import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:args/args.dart';
import 'package:collection/collection.dart';
import 'package:parselyzer/parselyzer.dart';
import 'package:pub_update_checker/pub_update_checker.dart';

const pmadCode = 'public_member_api_docs';
const optionContent = 'content';

final parser = ArgParser()
  ..addOption(
    optionContent,
    abbr: 'c',
    help: 'Comment content (defaults to `TODO`)',
    valueHelp: 'content',
  );

final magentaPen = AnsiPen()..magenta();
final greenPen = AnsiPen()..green();
final yellowPen = AnsiPen()..yellow();
final redPen = AnsiPen()..red();

void main(List<String> arguments) async {
  final newVersion = await PubUpdateChecker.check();
  if (newVersion != null) {
    print(
      yellowPen(
        'There is an update available: $newVersion. Run `dart pub global activate public_member_api_docs_todos` to update.',
      ),
    );
  }

  final ArgResults args;
  try {
    args = parser.parse(arguments);
  } catch (_) {
    print(magentaPen(parser.usage));
    exit(1);
  }

  final content = args[optionContent] as String? ?? 'TODO';

  print('Analyzing the current directory...');

  final analyzeProcessResult =
      await Process.run('dart', ['analyze', '--format=json']);

  final lintResult = AnalyzerResult.fromConsole(analyzeProcessResult.stdout);
  if (lintResult == null) {
    print(
      redPen(
        'Failed to parse lint result. This might mean there are no lint issues.',
      ),
    );
    exit(1);
  }

  final pmadDiagnostics = lintResult.diagnostics
      .where((diagnostic) => diagnostic.code == pmadCode)
      .groupListsBy((e) => e.location.file);

  if (pmadDiagnostics.isEmpty) {
    print(greenPen('No $pmadCode issues found'));
    exit(0);
  } else {
    final issues = pmadDiagnostics.values.expand((e) => e).length;
    print('Found $issues issues');
  }

  // Ask the user for confirmation
  stdout.write(yellowPen('Continue? (y/n) '));
  final confirmation = stdin.readLineSync();
  if (confirmation != 'y') {
    print(redPen('Aborting'));
    exit(1);
  }

  for (final entry in pmadDiagnostics.entries) {
    final file = File(entry.key);
    final lineNumbers = entry.value.map((e) => e.location.range.start.line);

    final lines = file.readAsLinesSync();
    final newContents = lines.mapIndexed((index, line) {
      // Indices in [lineNumbers] are 1 indexed
      // Indices in [lines] are 0 indexed
      if (lineNumbers.contains(index + 1)) {
        return '/// $content\n$line';
      } else {
        return line;
      }
    }).join('\n');

    file.writeAsStringSync(newContents);
    print('Fixed ${entry.key}');
  }

  print(greenPen('Done!'));
  print(yellowPen('Run `dart format .` to format the files'));

  exit(0);
}
