// Generated code. Do not modify.

import 'package:divkit/src/schema/div_accessibility.dart';
import 'package:divkit/src/schema/div_action.dart';
import 'package:divkit/src/schema/div_alignment_horizontal.dart';
import 'package:divkit/src/schema/div_alignment_vertical.dart';
import 'package:divkit/src/schema/div_animator.dart';
import 'package:divkit/src/schema/div_appearance_transition.dart';
import 'package:divkit/src/schema/div_background.dart';
import 'package:divkit/src/schema/div_base.dart';
import 'package:divkit/src/schema/div_border.dart';
import 'package:divkit/src/schema/div_change_transition.dart';
import 'package:divkit/src/schema/div_disappear_action.dart';
import 'package:divkit/src/schema/div_drawable.dart';
import 'package:divkit/src/schema/div_edge_insets.dart';
import 'package:divkit/src/schema/div_extension.dart';
import 'package:divkit/src/schema/div_focus.dart';
import 'package:divkit/src/schema/div_font_weight.dart';
import 'package:divkit/src/schema/div_function.dart';
import 'package:divkit/src/schema/div_layout_provider.dart';
import 'package:divkit/src/schema/div_match_parent_size.dart';
import 'package:divkit/src/schema/div_point.dart';
import 'package:divkit/src/schema/div_size.dart';
import 'package:divkit/src/schema/div_size_unit.dart';
import 'package:divkit/src/schema/div_tooltip.dart';
import 'package:divkit/src/schema/div_transform.dart';
import 'package:divkit/src/schema/div_transition_trigger.dart';
import 'package:divkit/src/schema/div_trigger.dart';
import 'package:divkit/src/schema/div_variable.dart';
import 'package:divkit/src/schema/div_visibility.dart';
import 'package:divkit/src/schema/div_visibility_action.dart';
import 'package:divkit/src/schema/div_wrap_content_size.dart';
import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

/// Slider for selecting a value in the range.
class DivSlider extends Resolvable with EquatableMixin implements DivBase {
  const DivSlider({
    this.accessibility = const DivAccessibility(),
    this.alignmentHorizontal,
    this.alignmentVertical,
    this.alpha = const ValueExpression(1.0),
    this.animators,
    this.background,
    this.border = const DivBorder(),
    this.columnSpan,
    this.disappearActions,
    this.extensions,
    this.focus,
    this.functions,
    this.height = const DivSize.divWrapContentSize(
      DivWrapContentSize(),
    ),
    this.id,
    this.layoutProvider,
    this.margins = const DivEdgeInsets(),
    this.maxValue = const ValueExpression(100),
    this.minValue = const ValueExpression(0),
    this.paddings = const DivEdgeInsets(),
    this.ranges,
    this.reuseId,
    this.rowSpan,
    this.secondaryValueAccessibility = const DivAccessibility(),
    this.selectedActions,
    this.thumbSecondaryStyle,
    this.thumbSecondaryTextStyle,
    this.thumbSecondaryValueVariable,
    required this.thumbStyle,
    this.thumbTextStyle,
    this.thumbValueVariable,
    this.tickMarkActiveStyle,
    this.tickMarkInactiveStyle,
    this.tooltips,
    required this.trackActiveStyle,
    required this.trackInactiveStyle,
    this.transform = const DivTransform(),
    this.transitionChange,
    this.transitionIn,
    this.transitionOut,
    this.transitionTriggers,
    this.variableTriggers,
    this.variables,
    this.visibility = const ValueExpression(DivVisibility.visible),
    this.visibilityAction,
    this.visibilityActions,
    this.width = const DivSize.divMatchParentSize(
      DivMatchParentSize(),
    ),
  });

  static const type = "slider";

  /// Accessibility settings.
  @override
  final DivAccessibility accessibility;

  /// Horizontal alignment of an element inside the parent element.
  @override
  final Expression<DivAlignmentHorizontal>? alignmentHorizontal;

  /// Vertical alignment of an element inside the parent element.
  @override
  final Expression<DivAlignmentVertical>? alignmentVertical;

  /// Sets transparency of the entire element: `0` — completely transparent, `1` — opaque.
  // constraint: number >= 0.0 && number <= 1.0; default value: 1.0
  @override
  final Expression<double> alpha;

  /// Declaration of animators that change variable values over time.
  @override
  final List<DivAnimator>? animators;

  /// Element background. It can contain multiple layers.
  @override
  final List<DivBackground>? background;

  /// Element stroke.
  @override
  final DivBorder border;

  /// Merges cells in a column of the [grid](div-grid.md) element.
  // constraint: number >= 0
  @override
  final Expression<int>? columnSpan;

  /// Actions when an element disappears from the screen.
  @override
  final List<DivDisappearAction>? disappearActions;

  /// Extensions for additional processing of an element. The list of extensions is given in  [DivExtension](https://divkit.tech/docs/en/concepts/extensions).
  @override
  final List<DivExtension>? extensions;

  /// Parameters when focusing on an element or losing focus.
  @override
  final DivFocus? focus;

  /// User functions.
  @override
  final List<DivFunction>? functions;

  /// Element height. For Android: if there is text in this or in a child element, specify height in `sp` to scale the element together with the text. To learn more about units of size measurement, see [Layout inside the card](https://divkit.tech/docs/en/concepts/layout).
  // default value: const DivSize.divWrapContentSize(DivWrapContentSize(),)
  @override
  final DivSize height;

  /// Element ID. It must be unique within the root element. It is used as `accessibilityIdentifier` on iOS.
  @override
  final String? id;

  /// Provides data on the actual size of the element.
  @override
  final DivLayoutProvider? layoutProvider;

  /// External margins from the element stroke.
  @override
  final DivEdgeInsets margins;

  /// Maximum value. It must be greater than the minimum value.
  // default value: 100
  final Expression<int> maxValue;

  /// Minimum value.
  // default value: 0
  final Expression<int> minValue;

  /// Internal margins from the element stroke.
  @override
  final DivEdgeInsets paddings;

  /// Section style.
  final List<DivSliderRange>? ranges;

  /// ID for the div object structure. Used to optimize block reuse. See [block reuse](https://divkit.tech/docs/en/concepts/reuse/reuse.md).
  @override
  final Expression<String>? reuseId;

  /// Merges cells in a string of the [grid](div-grid.md) element.
  // constraint: number >= 0
  @override
  final Expression<int>? rowSpan;

  /// Accessibility settings for the second pointer.
  final DivAccessibility secondaryValueAccessibility;

  /// List of [actions](div-action.md) to be executed when selecting an element in [pager](div-pager.md).
  @override
  final List<DivAction>? selectedActions;

  /// Style of the second pointer.
  final DivDrawable? thumbSecondaryStyle;

  /// Text style in the second pointer.
  final DivSliderTextStyle? thumbSecondaryTextStyle;

  /// Name of the variable to store the second pointer's current value.
  final String? thumbSecondaryValueVariable;

  /// Style of the first pointer.
  final DivDrawable thumbStyle;

  /// Text style in the first pointer.
  final DivSliderTextStyle? thumbTextStyle;

  /// Name of the variable to store the pointer's current value.
  final String? thumbValueVariable;

  /// Style of active serifs.
  final DivDrawable? tickMarkActiveStyle;

  /// Style of inactive serifs.
  final DivDrawable? tickMarkInactiveStyle;

  /// Tooltips linked to an element. A tooltip can be shown by `div-action://show_tooltip?id=`, hidden by `div-action://hide_tooltip?id=` where `id` — tooltip id.
  @override
  final List<DivTooltip>? tooltips;

  /// Style of the active part of a scale.
  final DivDrawable trackActiveStyle;

  /// Style of the inactive part of a scale.
  final DivDrawable trackInactiveStyle;

  /// Applies the passed transformation to the element. Content that doesn't fit into the original view area is cut off.
  @override
  final DivTransform transform;

  /// Change animation. It is played when the position or size of an element changes in the new layout.
  @override
  final DivChangeTransition? transitionChange;

  /// Appearance animation. It is played when an element with a new ID appears. To learn more about the concept of transitions, see [Animated transitions](https://divkit.tech/docs/en/concepts/interaction#animation/transition-animation).
  @override
  final DivAppearanceTransition? transitionIn;

  /// Disappearance animation. It is played when an element disappears in the new layout.
  @override
  final DivAppearanceTransition? transitionOut;

  /// Animation starting triggers. Default value: `[state_change, visibility_change]`.
  // at least 1 elements
  @override
  final List<DivTransitionTrigger>? transitionTriggers;

  /// Triggers for changing variables within an element.
  @override
  final List<DivTrigger>? variableTriggers;

  /// Declaration of variables that can be used within an element. Variables declared in this array can only be used within the element and its child elements.
  @override
  final List<DivVariable>? variables;

  /// Element visibility.
  // default value: DivVisibility.visible
  @override
  final Expression<DivVisibility> visibility;

  /// Tracking visibility of a single element. Not used if the `visibility_actions` parameter is set.
  @override
  final DivVisibilityAction? visibilityAction;

  /// Actions when an element appears on the screen.
  @override
  final List<DivVisibilityAction>? visibilityActions;

  /// Element width.
  // default value: const DivSize.divMatchParentSize(DivMatchParentSize(),)
  @override
  final DivSize width;

  @override
  List<Object?> get props => [
        accessibility,
        alignmentHorizontal,
        alignmentVertical,
        alpha,
        animators,
        background,
        border,
        columnSpan,
        disappearActions,
        extensions,
        focus,
        functions,
        height,
        id,
        layoutProvider,
        margins,
        maxValue,
        minValue,
        paddings,
        ranges,
        reuseId,
        rowSpan,
        secondaryValueAccessibility,
        selectedActions,
        thumbSecondaryStyle,
        thumbSecondaryTextStyle,
        thumbSecondaryValueVariable,
        thumbStyle,
        thumbTextStyle,
        thumbValueVariable,
        tickMarkActiveStyle,
        tickMarkInactiveStyle,
        tooltips,
        trackActiveStyle,
        trackInactiveStyle,
        transform,
        transitionChange,
        transitionIn,
        transitionOut,
        transitionTriggers,
        variableTriggers,
        variables,
        visibility,
        visibilityAction,
        visibilityActions,
        width,
      ];

  DivSlider copyWith({
    DivAccessibility? accessibility,
    Expression<DivAlignmentHorizontal>? Function()? alignmentHorizontal,
    Expression<DivAlignmentVertical>? Function()? alignmentVertical,
    Expression<double>? alpha,
    List<DivAnimator>? Function()? animators,
    List<DivBackground>? Function()? background,
    DivBorder? border,
    Expression<int>? Function()? columnSpan,
    List<DivDisappearAction>? Function()? disappearActions,
    List<DivExtension>? Function()? extensions,
    DivFocus? Function()? focus,
    List<DivFunction>? Function()? functions,
    DivSize? height,
    String? Function()? id,
    DivLayoutProvider? Function()? layoutProvider,
    DivEdgeInsets? margins,
    Expression<int>? maxValue,
    Expression<int>? minValue,
    DivEdgeInsets? paddings,
    List<DivSliderRange>? Function()? ranges,
    Expression<String>? Function()? reuseId,
    Expression<int>? Function()? rowSpan,
    DivAccessibility? secondaryValueAccessibility,
    List<DivAction>? Function()? selectedActions,
    DivDrawable? Function()? thumbSecondaryStyle,
    DivSliderTextStyle? Function()? thumbSecondaryTextStyle,
    String? Function()? thumbSecondaryValueVariable,
    DivDrawable? thumbStyle,
    DivSliderTextStyle? Function()? thumbTextStyle,
    String? Function()? thumbValueVariable,
    DivDrawable? Function()? tickMarkActiveStyle,
    DivDrawable? Function()? tickMarkInactiveStyle,
    List<DivTooltip>? Function()? tooltips,
    DivDrawable? trackActiveStyle,
    DivDrawable? trackInactiveStyle,
    DivTransform? transform,
    DivChangeTransition? Function()? transitionChange,
    DivAppearanceTransition? Function()? transitionIn,
    DivAppearanceTransition? Function()? transitionOut,
    List<DivTransitionTrigger>? Function()? transitionTriggers,
    List<DivTrigger>? Function()? variableTriggers,
    List<DivVariable>? Function()? variables,
    Expression<DivVisibility>? visibility,
    DivVisibilityAction? Function()? visibilityAction,
    List<DivVisibilityAction>? Function()? visibilityActions,
    DivSize? width,
  }) =>
      DivSlider(
        accessibility: accessibility ?? this.accessibility,
        alignmentHorizontal: alignmentHorizontal != null
            ? alignmentHorizontal.call()
            : this.alignmentHorizontal,
        alignmentVertical: alignmentVertical != null
            ? alignmentVertical.call()
            : this.alignmentVertical,
        alpha: alpha ?? this.alpha,
        animators: animators != null ? animators.call() : this.animators,
        background: background != null ? background.call() : this.background,
        border: border ?? this.border,
        columnSpan: columnSpan != null ? columnSpan.call() : this.columnSpan,
        disappearActions: disappearActions != null
            ? disappearActions.call()
            : this.disappearActions,
        extensions: extensions != null ? extensions.call() : this.extensions,
        focus: focus != null ? focus.call() : this.focus,
        functions: functions != null ? functions.call() : this.functions,
        height: height ?? this.height,
        id: id != null ? id.call() : this.id,
        layoutProvider: layoutProvider != null
            ? layoutProvider.call()
            : this.layoutProvider,
        margins: margins ?? this.margins,
        maxValue: maxValue ?? this.maxValue,
        minValue: minValue ?? this.minValue,
        paddings: paddings ?? this.paddings,
        ranges: ranges != null ? ranges.call() : this.ranges,
        reuseId: reuseId != null ? reuseId.call() : this.reuseId,
        rowSpan: rowSpan != null ? rowSpan.call() : this.rowSpan,
        secondaryValueAccessibility:
            secondaryValueAccessibility ?? this.secondaryValueAccessibility,
        selectedActions: selectedActions != null
            ? selectedActions.call()
            : this.selectedActions,
        thumbSecondaryStyle: thumbSecondaryStyle != null
            ? thumbSecondaryStyle.call()
            : this.thumbSecondaryStyle,
        thumbSecondaryTextStyle: thumbSecondaryTextStyle != null
            ? thumbSecondaryTextStyle.call()
            : this.thumbSecondaryTextStyle,
        thumbSecondaryValueVariable: thumbSecondaryValueVariable != null
            ? thumbSecondaryValueVariable.call()
            : this.thumbSecondaryValueVariable,
        thumbStyle: thumbStyle ?? this.thumbStyle,
        thumbTextStyle: thumbTextStyle != null
            ? thumbTextStyle.call()
            : this.thumbTextStyle,
        thumbValueVariable: thumbValueVariable != null
            ? thumbValueVariable.call()
            : this.thumbValueVariable,
        tickMarkActiveStyle: tickMarkActiveStyle != null
            ? tickMarkActiveStyle.call()
            : this.tickMarkActiveStyle,
        tickMarkInactiveStyle: tickMarkInactiveStyle != null
            ? tickMarkInactiveStyle.call()
            : this.tickMarkInactiveStyle,
        tooltips: tooltips != null ? tooltips.call() : this.tooltips,
        trackActiveStyle: trackActiveStyle ?? this.trackActiveStyle,
        trackInactiveStyle: trackInactiveStyle ?? this.trackInactiveStyle,
        transform: transform ?? this.transform,
        transitionChange: transitionChange != null
            ? transitionChange.call()
            : this.transitionChange,
        transitionIn:
            transitionIn != null ? transitionIn.call() : this.transitionIn,
        transitionOut:
            transitionOut != null ? transitionOut.call() : this.transitionOut,
        transitionTriggers: transitionTriggers != null
            ? transitionTriggers.call()
            : this.transitionTriggers,
        variableTriggers: variableTriggers != null
            ? variableTriggers.call()
            : this.variableTriggers,
        variables: variables != null ? variables.call() : this.variables,
        visibility: visibility ?? this.visibility,
        visibilityAction: visibilityAction != null
            ? visibilityAction.call()
            : this.visibilityAction,
        visibilityActions: visibilityActions != null
            ? visibilityActions.call()
            : this.visibilityActions,
        width: width ?? this.width,
      );

  static DivSlider? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivSlider(
        accessibility: safeParseObj(
          DivAccessibility.fromJson(json['accessibility']),
          fallback: const DivAccessibility(),
        )!,
        alignmentHorizontal: safeParseStrEnumExpr(
          json['alignment_horizontal'],
          parse: DivAlignmentHorizontal.fromJson,
        ),
        alignmentVertical: safeParseStrEnumExpr(
          json['alignment_vertical'],
          parse: DivAlignmentVertical.fromJson,
        ),
        alpha: safeParseDoubleExpr(
          json['alpha'],
          fallback: 1.0,
        )!,
        animators: safeParseObj(
          safeListMap(
            json['animators'],
            (v) => safeParseObj(
              DivAnimator.fromJson(v),
            )!,
          ),
        ),
        background: safeParseObj(
          safeListMap(
            json['background'],
            (v) => safeParseObj(
              DivBackground.fromJson(v),
            )!,
          ),
        ),
        border: safeParseObj(
          DivBorder.fromJson(json['border']),
          fallback: const DivBorder(),
        )!,
        columnSpan: safeParseIntExpr(
          json['column_span'],
        ),
        disappearActions: safeParseObj(
          safeListMap(
            json['disappear_actions'],
            (v) => safeParseObj(
              DivDisappearAction.fromJson(v),
            )!,
          ),
        ),
        extensions: safeParseObj(
          safeListMap(
            json['extensions'],
            (v) => safeParseObj(
              DivExtension.fromJson(v),
            )!,
          ),
        ),
        focus: safeParseObj(
          DivFocus.fromJson(json['focus']),
        ),
        functions: safeParseObj(
          safeListMap(
            json['functions'],
            (v) => safeParseObj(
              DivFunction.fromJson(v),
            )!,
          ),
        ),
        height: safeParseObj(
          DivSize.fromJson(json['height']),
          fallback: const DivSize.divWrapContentSize(
            DivWrapContentSize(),
          ),
        )!,
        id: safeParseStr(
          json['id']?.toString(),
        ),
        layoutProvider: safeParseObj(
          DivLayoutProvider.fromJson(json['layout_provider']),
        ),
        margins: safeParseObj(
          DivEdgeInsets.fromJson(json['margins']),
          fallback: const DivEdgeInsets(),
        )!,
        maxValue: safeParseIntExpr(
          json['max_value'],
          fallback: 100,
        )!,
        minValue: safeParseIntExpr(
          json['min_value'],
          fallback: 0,
        )!,
        paddings: safeParseObj(
          DivEdgeInsets.fromJson(json['paddings']),
          fallback: const DivEdgeInsets(),
        )!,
        ranges: safeParseObj(
          safeListMap(
            json['ranges'],
            (v) => safeParseObj(
              DivSliderRange.fromJson(v),
            )!,
          ),
        ),
        reuseId: safeParseStrExpr(
          json['reuse_id']?.toString(),
        ),
        rowSpan: safeParseIntExpr(
          json['row_span'],
        ),
        secondaryValueAccessibility: safeParseObj(
          DivAccessibility.fromJson(json['secondary_value_accessibility']),
          fallback: const DivAccessibility(),
        )!,
        selectedActions: safeParseObj(
          safeListMap(
            json['selected_actions'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
        thumbSecondaryStyle: safeParseObj(
          DivDrawable.fromJson(json['thumb_secondary_style']),
        ),
        thumbSecondaryTextStyle: safeParseObj(
          DivSliderTextStyle.fromJson(json['thumb_secondary_text_style']),
        ),
        thumbSecondaryValueVariable: safeParseStr(
          json['thumb_secondary_value_variable']?.toString(),
        ),
        thumbStyle: safeParseObj(
          DivDrawable.fromJson(json['thumb_style']),
        )!,
        thumbTextStyle: safeParseObj(
          DivSliderTextStyle.fromJson(json['thumb_text_style']),
        ),
        thumbValueVariable: safeParseStr(
          json['thumb_value_variable']?.toString(),
        ),
        tickMarkActiveStyle: safeParseObj(
          DivDrawable.fromJson(json['tick_mark_active_style']),
        ),
        tickMarkInactiveStyle: safeParseObj(
          DivDrawable.fromJson(json['tick_mark_inactive_style']),
        ),
        tooltips: safeParseObj(
          safeListMap(
            json['tooltips'],
            (v) => safeParseObj(
              DivTooltip.fromJson(v),
            )!,
          ),
        ),
        trackActiveStyle: safeParseObj(
          DivDrawable.fromJson(json['track_active_style']),
        )!,
        trackInactiveStyle: safeParseObj(
          DivDrawable.fromJson(json['track_inactive_style']),
        )!,
        transform: safeParseObj(
          DivTransform.fromJson(json['transform']),
          fallback: const DivTransform(),
        )!,
        transitionChange: safeParseObj(
          DivChangeTransition.fromJson(json['transition_change']),
        ),
        transitionIn: safeParseObj(
          DivAppearanceTransition.fromJson(json['transition_in']),
        ),
        transitionOut: safeParseObj(
          DivAppearanceTransition.fromJson(json['transition_out']),
        ),
        transitionTriggers: safeParseObj(
          safeListMap(
            json['transition_triggers'],
            (v) => safeParseStrEnum(
              v,
              parse: DivTransitionTrigger.fromJson,
            )!,
          ),
        ),
        variableTriggers: safeParseObj(
          safeListMap(
            json['variable_triggers'],
            (v) => safeParseObj(
              DivTrigger.fromJson(v),
            )!,
          ),
        ),
        variables: safeParseObj(
          safeListMap(
            json['variables'],
            (v) => safeParseObj(
              DivVariable.fromJson(v),
            )!,
          ),
        ),
        visibility: safeParseStrEnumExpr(
          json['visibility'],
          parse: DivVisibility.fromJson,
          fallback: DivVisibility.visible,
        )!,
        visibilityAction: safeParseObj(
          DivVisibilityAction.fromJson(json['visibility_action']),
        ),
        visibilityActions: safeParseObj(
          safeListMap(
            json['visibility_actions'],
            (v) => safeParseObj(
              DivVisibilityAction.fromJson(v),
            )!,
          ),
        ),
        width: safeParseObj(
          DivSize.fromJson(json['width']),
          fallback: const DivSize.divMatchParentSize(
            DivMatchParentSize(),
          ),
        )!,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  DivSlider resolve(DivVariableContext context) {
    accessibility.resolve(context);
    alignmentHorizontal?.resolve(context);
    alignmentVertical?.resolve(context);
    alpha.resolve(context);
    safeListResolve(animators, (v) => v.resolve(context));
    safeListResolve(background, (v) => v.resolve(context));
    border.resolve(context);
    columnSpan?.resolve(context);
    safeListResolve(disappearActions, (v) => v.resolve(context));
    safeListResolve(extensions, (v) => v.resolve(context));
    focus?.resolve(context);
    safeListResolve(functions, (v) => v.resolve(context));
    height.resolve(context);
    layoutProvider?.resolve(context);
    margins.resolve(context);
    maxValue.resolve(context);
    minValue.resolve(context);
    paddings.resolve(context);
    safeListResolve(ranges, (v) => v.resolve(context));
    reuseId?.resolve(context);
    rowSpan?.resolve(context);
    secondaryValueAccessibility.resolve(context);
    safeListResolve(selectedActions, (v) => v.resolve(context));
    thumbSecondaryStyle?.resolve(context);
    thumbSecondaryTextStyle?.resolve(context);
    thumbStyle.resolve(context);
    thumbTextStyle?.resolve(context);
    tickMarkActiveStyle?.resolve(context);
    tickMarkInactiveStyle?.resolve(context);
    safeListResolve(tooltips, (v) => v.resolve(context));
    trackActiveStyle.resolve(context);
    trackInactiveStyle.resolve(context);
    transform.resolve(context);
    transitionChange?.resolve(context);
    transitionIn?.resolve(context);
    transitionOut?.resolve(context);
    safeListResolve(transitionTriggers, (v) => v.resolve(context));
    safeListResolve(variableTriggers, (v) => v.resolve(context));
    safeListResolve(variables, (v) => v.resolve(context));
    visibility.resolve(context);
    visibilityAction?.resolve(context);
    safeListResolve(visibilityActions, (v) => v.resolve(context));
    width.resolve(context);
    return this;
  }
}

class DivSliderTextStyle extends Resolvable with EquatableMixin {
  const DivSliderTextStyle({
    required this.fontSize,
    this.fontSizeUnit = const ValueExpression(DivSizeUnit.sp),
    this.fontWeight = const ValueExpression(DivFontWeight.regular),
    this.fontWeightValue,
    this.offset,
    this.textColor = const ValueExpression(Color(0xFF000000)),
  });

  /// Font size.
  // constraint: number >= 0
  final Expression<int> fontSize;
  // default value: DivSizeUnit.sp
  final Expression<DivSizeUnit> fontSizeUnit;

  /// Style.
  // default value: DivFontWeight.regular
  final Expression<DivFontWeight> fontWeight;

  /// Style. Numeric value.
  // constraint: number > 0
  final Expression<int>? fontWeightValue;

  /// Shift relative to the center.
  final DivPoint? offset;

  /// Text color.
  // default value: const Color(0xFF000000)
  final Expression<Color> textColor;

  @override
  List<Object?> get props => [
        fontSize,
        fontSizeUnit,
        fontWeight,
        fontWeightValue,
        offset,
        textColor,
      ];

  DivSliderTextStyle copyWith({
    Expression<int>? fontSize,
    Expression<DivSizeUnit>? fontSizeUnit,
    Expression<DivFontWeight>? fontWeight,
    Expression<int>? Function()? fontWeightValue,
    DivPoint? Function()? offset,
    Expression<Color>? textColor,
  }) =>
      DivSliderTextStyle(
        fontSize: fontSize ?? this.fontSize,
        fontSizeUnit: fontSizeUnit ?? this.fontSizeUnit,
        fontWeight: fontWeight ?? this.fontWeight,
        fontWeightValue: fontWeightValue != null
            ? fontWeightValue.call()
            : this.fontWeightValue,
        offset: offset != null ? offset.call() : this.offset,
        textColor: textColor ?? this.textColor,
      );

  static DivSliderTextStyle? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivSliderTextStyle(
        fontSize: safeParseIntExpr(
          json['font_size'],
        )!,
        fontSizeUnit: safeParseStrEnumExpr(
          json['font_size_unit'],
          parse: DivSizeUnit.fromJson,
          fallback: DivSizeUnit.sp,
        )!,
        fontWeight: safeParseStrEnumExpr(
          json['font_weight'],
          parse: DivFontWeight.fromJson,
          fallback: DivFontWeight.regular,
        )!,
        fontWeightValue: safeParseIntExpr(
          json['font_weight_value'],
        ),
        offset: safeParseObj(
          DivPoint.fromJson(json['offset']),
        ),
        textColor: safeParseColorExpr(
          json['text_color'],
          fallback: const Color(0xFF000000),
        )!,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  DivSliderTextStyle resolve(DivVariableContext context) {
    fontSize.resolve(context);
    fontSizeUnit.resolve(context);
    fontWeight.resolve(context);
    fontWeightValue?.resolve(context);
    offset?.resolve(context);
    textColor.resolve(context);
    return this;
  }
}

class DivSliderRange extends Resolvable with EquatableMixin {
  const DivSliderRange({
    this.end,
    this.margins = const DivEdgeInsets(),
    this.start,
    this.trackActiveStyle,
    this.trackInactiveStyle,
  });

  /// End of section.
  final Expression<int>? end;

  /// Section margins. Only uses horizontal margins.
  final DivEdgeInsets margins;

  /// Start of section.
  final Expression<int>? start;

  /// Style of the active part of a scale.
  final DivDrawable? trackActiveStyle;

  /// Style of the inactive part of a scale.
  final DivDrawable? trackInactiveStyle;

  @override
  List<Object?> get props => [
        end,
        margins,
        start,
        trackActiveStyle,
        trackInactiveStyle,
      ];

  DivSliderRange copyWith({
    Expression<int>? Function()? end,
    DivEdgeInsets? margins,
    Expression<int>? Function()? start,
    DivDrawable? Function()? trackActiveStyle,
    DivDrawable? Function()? trackInactiveStyle,
  }) =>
      DivSliderRange(
        end: end != null ? end.call() : this.end,
        margins: margins ?? this.margins,
        start: start != null ? start.call() : this.start,
        trackActiveStyle: trackActiveStyle != null
            ? trackActiveStyle.call()
            : this.trackActiveStyle,
        trackInactiveStyle: trackInactiveStyle != null
            ? trackInactiveStyle.call()
            : this.trackInactiveStyle,
      );

  static DivSliderRange? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivSliderRange(
        end: safeParseIntExpr(
          json['end'],
        ),
        margins: safeParseObj(
          DivEdgeInsets.fromJson(json['margins']),
          fallback: const DivEdgeInsets(),
        )!,
        start: safeParseIntExpr(
          json['start'],
        ),
        trackActiveStyle: safeParseObj(
          DivDrawable.fromJson(json['track_active_style']),
        ),
        trackInactiveStyle: safeParseObj(
          DivDrawable.fromJson(json['track_inactive_style']),
        ),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  DivSliderRange resolve(DivVariableContext context) {
    end?.resolve(context);
    margins.resolve(context);
    start?.resolve(context);
    trackActiveStyle?.resolve(context);
    trackInactiveStyle?.resolve(context);
    return this;
  }
}
