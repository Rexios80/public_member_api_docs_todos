// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lint_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LintResult _$LintResultFromJson(Map<String, dynamic> json) => LintResult(
      version: json['version'] as int,
      diagnostics: (json['diagnostics'] as List<dynamic>)
          .map((e) => LintDiagnostic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LintResultToJson(LintResult instance) =>
    <String, dynamic>{
      'version': instance.version,
      'diagnostics': instance.diagnostics,
    };

LintDiagnostic _$LintDiagnosticFromJson(Map<String, dynamic> json) =>
    LintDiagnostic(
      code: json['code'] as String,
      location: LintLocation.fromJson(json['location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LintDiagnosticToJson(LintDiagnostic instance) =>
    <String, dynamic>{
      'code': instance.code,
      'location': instance.location,
    };

LintLocation _$LintLocationFromJson(Map<String, dynamic> json) => LintLocation(
      file: json['file'] as String,
      range: LintLocationRange.fromJson(json['range'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LintLocationToJson(LintLocation instance) =>
    <String, dynamic>{
      'file': instance.file,
      'range': instance.range,
    };

LintLocationRange _$LintLocationRangeFromJson(Map<String, dynamic> json) =>
    LintLocationRange(
      start: LintLocationRangePoint.fromJson(
          json['start'] as Map<String, dynamic>),
      end: LintLocationRangePoint.fromJson(json['end'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LintLocationRangeToJson(LintLocationRange instance) =>
    <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
    };

LintLocationRangePoint _$LintLocationRangePointFromJson(
        Map<String, dynamic> json) =>
    LintLocationRangePoint(
      column: json['column'] as int,
      line: json['line'] as int,
      offset: json['offset'] as int,
    );

Map<String, dynamic> _$LintLocationRangePointToJson(
        LintLocationRangePoint instance) =>
    <String, dynamic>{
      'column': instance.column,
      'line': instance.line,
      'offset': instance.offset,
    };
