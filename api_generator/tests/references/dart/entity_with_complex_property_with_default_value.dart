// Generated code. Do not modify.

import 'package:equatable/equatable.dart';

import 'package:divkit/src/utils/parsing_utils.dart';


class EntityWithComplexPropertyWithDefaultValue extends Resolvable with EquatableMixin  {
  const EntityWithComplexPropertyWithDefaultValue({
    this.property = const EntityWithComplexPropertyWithDefaultValueProperty(value: ValueExpression("Default text",),),
  });

  static const type = "entity_with_complex_property_with_default_value";
   // default value: const EntityWithComplexPropertyWithDefaultValueProperty(value: ValueExpression("Default text",),)
  final EntityWithComplexPropertyWithDefaultValueProperty property;

  @override
  List<Object?> get props => [
        property,
      ];

  EntityWithComplexPropertyWithDefaultValue copyWith({
      EntityWithComplexPropertyWithDefaultValueProperty?  property,
  }) => EntityWithComplexPropertyWithDefaultValue(
      property: property ?? this.property,
    );

  static EntityWithComplexPropertyWithDefaultValue? fromJson(Map<String, dynamic>? json,) {
    if (json == null) {
      return null;
    }
    try {
      return EntityWithComplexPropertyWithDefaultValue(
        property: safeParseObj(EntityWithComplexPropertyWithDefaultValueProperty.fromJson(json['property']), fallback: const EntityWithComplexPropertyWithDefaultValueProperty(value: ValueExpression("Default text",),),)!,
      );
    } catch (e, st) {
      return null;
    }
  }

  EntityWithComplexPropertyWithDefaultValue resolve(DivVariableContext context) {
    property?.resolve(context);
    return this;
  }
}


class EntityWithComplexPropertyWithDefaultValueProperty extends Resolvable with EquatableMixin  {
  const EntityWithComplexPropertyWithDefaultValueProperty({
    required this.value,
  });

  final Expression<String> value;

  @override
  List<Object?> get props => [
        value,
      ];

  EntityWithComplexPropertyWithDefaultValueProperty copyWith({
      Expression<String>?  value,
  }) => EntityWithComplexPropertyWithDefaultValueProperty(
      value: value ?? this.value,
    );

  static EntityWithComplexPropertyWithDefaultValueProperty? fromJson(Map<String, dynamic>? json,) {
    if (json == null) {
      return null;
    }
    try {
      return EntityWithComplexPropertyWithDefaultValueProperty(
        value: safeParseStrExpr(json['value']?.toString(),)!,
      );
    } catch (e, st) {
      return null;
    }
  }

  EntityWithComplexPropertyWithDefaultValueProperty resolve(DivVariableContext context) {
    value.resolve(context);
    return this;
  }
}
