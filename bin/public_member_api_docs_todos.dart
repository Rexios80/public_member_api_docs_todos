import 'dart:convert';
import 'dart:io';

import 'package:ansicolor/ansicolor.dart';
import 'package:args/args.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart';
import 'package:pub_update_checker/pub_update_checker.dart';

import 'lint_result.dart';
import 'pmad_issue.dart';

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

  final analyzeProcessResult =
      await Process.run('dart', ['analyze', '--format=json']);
  final analyzeResult = (analyzeProcessResult.stdout as String)
      .split('\n')
      .skip(1)
      .join('')
      .trim();

  final lintResult = LintResult.fromJson(jsonDecode(analyzeResult));

  final pmadDiagnostics =
      lintResult.diagnostics.where((diagnostic) => diagnostic.code == pmadCode);

  if (pmadDiagnostics.isEmpty) {
    print(greenPen('No $pmadCode issues found'));
    exit(0);
  } else {
    print('Found ${pmadDiagnostics.length} issues');
  }

  // Ask the user for confirmation
  stdout.write(yellowPen('Continue? (y/n) '));
  final confirmation = stdin.readLineSync();
  if (confirmation != 'y') {
    print(redPen('Aborting'));
    exit(1);
  }

  final pmadIssues = pmadDiagnostics
      .map((diagnostic) => diagnostic.location)
      .groupListsBy((location) => location.file)
      .entries
      .map(
        (e) => PmadIssue(
          path: relative(e.key),
          lineNumbers: e.value.map((e) => e.range.start.line),
        ),
      );

  for (final issue in pmadIssues) {
    await issue.fix(content: content);
    print('Fixed ${issue.path}');
  }

  print(greenPen('Done!'));
}
