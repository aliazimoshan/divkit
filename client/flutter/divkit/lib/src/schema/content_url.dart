// Generated code. Do not modify.

import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

class ContentUrl extends Resolvable with EquatableMixin {
  const ContentUrl({
    required this.value,
  });

  static const type = "url";
  final Expression<Uri> value;

  @override
  List<Object?> get props => [
        value,
      ];

  ContentUrl copyWith({
    Expression<Uri>? value,
  }) =>
      ContentUrl(
        value: value ?? this.value,
      );

  static ContentUrl? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return ContentUrl(
        value: safeParseUriExpr(json['value'])!,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  ContentUrl resolve(DivVariableContext context) {
    value.resolve(context);
    return this;
  }
}
