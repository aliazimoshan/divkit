// Generated code. Do not modify.

import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

/// An integer variable.
class IntegerVariable extends Resolvable with EquatableMixin {
  const IntegerVariable({
    required this.name,
    required this.value,
  });

  static const type = "integer";

  /// Variable name.
  final String name;

  /// Value.
  final int value;

  @override
  List<Object?> get props => [
        name,
        value,
      ];

  IntegerVariable copyWith({
    String? name,
    int? value,
  }) =>
      IntegerVariable(
        name: name ?? this.name,
        value: value ?? this.value,
      );

  static IntegerVariable? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return IntegerVariable(
        name: safeParseStr(
          json['name']?.toString(),
        )!,
        value: safeParseInt(
          json['value'],
        )!,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  IntegerVariable resolve(DivVariableContext context) {
    return this;
  }
}
