import 'package:divkit/src/core/widgets/base/div_base_widget.dart';
import 'package:divkit/src/core/widgets/separator/div_separator_model.dart';
import 'package:divkit/src/generated_sources/div_separator.dart';
import 'package:divkit/src/utils/provider.dart';
import 'package:flutter/material.dart';

class DivSeparatorWidget extends StatefulWidget {
  final DivSeparator data;

  const DivSeparatorWidget(
    this.data, {
    super.key,
  });

  @override
  State<DivSeparatorWidget> createState() => _DivSeparatorWidgetState();
}

class _DivSeparatorWidgetState extends State<DivSeparatorWidget> {
  Stream<DivSeparatorModel>? stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    stream ??= DivSeparatorModel.from(context, widget.data);
  }

  @override
  void didUpdateWidget(covariant DivSeparatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.data != oldWidget.data) {
      stream = DivSeparatorModel.from(context, widget.data);
    }
  }

  @override
  Widget build(BuildContext context) => DivBaseWidget(
        data: widget.data,
        action: widget.data.action,
        actions: widget.data.actions,
        longtapActions: widget.data.longtapActions,
        actionAnimation: widget.data.actionAnimation,
        child: StreamBuilder<DivSeparatorModel>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final model = snapshot.requireData;
              final orientation = model.orientation;

              final double width = orientation == Axis.horizontal
                  ? model.width.map(
                      fixed: (fixed) => fixed.size,
                      flex: (_) => double.infinity,
                      wrapped: (wrapped) =>
                          wrapped.maxSize?.size ?? double.infinity,
                    )
                  : model.height.map(
                      fixed: (fixed) => fixed.size,
                      flex: (_) => double.infinity,
                      wrapped: (wrapped) =>
                          wrapped.maxSize?.size ?? double.infinity,
                    );

              final double height = orientation == Axis.vertical
                  ? model.height.map(
                      fixed: (fixed) => fixed.size,
                      flex: (_) => double.infinity,
                      wrapped: (wrapped) =>
                          wrapped.maxSize?.size ?? double.infinity,
                    )
                  : model.width.map(
                      fixed: (fixed) => fixed.size,
                      flex: (_) => double.infinity,
                      wrapped: (wrapped) =>
                          wrapped.maxSize?.size ?? double.infinity,
                    );

              final Widget separator = Container(
                width: 1,
                height: 20,
                color: model.color,
              );

              if (model.margins != null) {
                return Padding(
                  padding: model.margins!,
                  child: separator,
                );
              }

              return separator;
            }

            return const SizedBox.shrink();
          },
        ),
      );

  @override
  void dispose() {
    stream = null;
    super.dispose();
  }
}
