import 'dart:io';
import 'package:collection/collection.dart';

class PmadIssue {
  final String path;
  final Iterable<int> lineNumbers;

  PmadIssue({
    required this.path,
    required this.lineNumbers,
  });

  Future<void> fix({required String content}) async {
    final file = File(path);
    final contents = await file.readAsString();
    final lines = contents.split('\n');
    final newContents = lines.mapIndexed((index, line) {
      // Indices in [lineNumbers] are 1 indexed
      // Indices in [lines] are 0 indexed
      if (lineNumbers.contains(index + 1)) {
        return '/// $content\n$line';
      } else {
        return line;
      }
    }).join('\n');
    await file.writeAsString(newContents);
  }
}
