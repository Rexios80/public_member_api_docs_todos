import 'package:json_annotation/json_annotation.dart';

part 'lint_result.g.dart';

@JsonSerializable()
class LintResult {
  final int version;
  final List<LintDiagnostic> diagnostics;

  LintResult({
    required this.version,
    required this.diagnostics,
  });

  factory LintResult.fromJson(Map<String, dynamic> json) =>
      _$LintResultFromJson(json);

  Map<String, dynamic> toJson() => _$LintResultToJson(this);
}

@JsonSerializable()
class LintDiagnostic {
  final String code;
  final LintLocation location;

  LintDiagnostic({
    required this.code,
    required this.location,
  });

  factory LintDiagnostic.fromJson(Map<String, dynamic> json) =>
      _$LintDiagnosticFromJson(json);

  Map<String, dynamic> toJson() => _$LintDiagnosticToJson(this);
}

@JsonSerializable()
class LintLocation {
  final String file;
  final LintLocationRange range;

  LintLocation({
    required this.file,
    required this.range,
  });

  factory LintLocation.fromJson(Map<String, dynamic> json) =>
      _$LintLocationFromJson(json);

  Map<String, dynamic> toJson() => _$LintLocationToJson(this);
}

@JsonSerializable()
class LintLocationRange {
  final LintLocationRangePoint start;
  final LintLocationRangePoint end;

  LintLocationRange({
    required this.start,
    required this.end,
  });

  factory LintLocationRange.fromJson(Map<String, dynamic> json) =>
      _$LintLocationRangeFromJson(json);

  Map<String, dynamic> toJson() => _$LintLocationRangeToJson(this);
}

@JsonSerializable()
class LintLocationRangePoint {
  final int column;
  final int line;
  final int offset;

  LintLocationRangePoint({
    required this.column,
    required this.line,
    required this.offset,
  });

  factory LintLocationRangePoint.fromJson(Map<String, dynamic> json) =>
      _$LintLocationRangePointFromJson(json);

  Map<String, dynamic> toJson() => _$LintLocationRangePointToJson(this);
}
