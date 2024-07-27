import 'package:divkit/divkit.dart';
import 'package:divkit/src/core/protocol/div_context.dart';
import 'package:divkit/src/generated_sources/div_separator.dart';
import 'package:divkit/src/utils/converters.dart';
import 'package:divkit/src/utils/provider.dart';
import 'package:divkit/src/utils/size_converters.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:divkit/src/utils/div_scaling_model.dart';

class DivSeparatorModel with EquatableMixin {
  final PassDivSize width;
  final PassDivSize height;
  final Color color;
  final Axis orientation;
  final EdgeInsetsGeometry? margins;

  const DivSeparatorModel({
    required this.width,
    required this.height,
    required this.color,
    required this.orientation,
    this.margins,
  });

  static Stream<DivSeparatorModel> from(
    BuildContext context,
    DivSeparator data,
  ) {
    final variables =
        DivKitProvider.watch<DivContext>(context)!.variableManager;

    final divScalingModel = DivKitProvider.watch<DivScalingModel>(context);
    final viewScale = divScalingModel?.viewScale ?? 1;

    return variables.watch<DivSeparatorModel>((context) async {
      final color =
          await data.delimiterStyle.color.resolveValue(context: context);

      final width =
          await data.width.resolve(context: context, viewScale: viewScale);
      final height =
          await data.height.resolve(context: context, viewScale: viewScale);

      return DivSeparatorModel(
        width: width,
        height: height,
        color: color,
        orientation: data.delimiterStyle.orientation.value ==
                DivSeparatorDelimiterStyleOrientation.vertical
            ? Axis.vertical
            : Axis.horizontal,
        margins: await data.margins.resolve(
          context: context,
          viewScale: viewScale,
        ),
      );
    }).distinct();
  }

  @override
  List<Object?> get props => [
        width,
        height,
        color,
        orientation,
        margins,
      ];
}
