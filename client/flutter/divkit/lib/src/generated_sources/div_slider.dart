// Generated code. Do not modify.

import 'package:equatable/equatable.dart';

import '../utils/parsing_utils.dart';
import 'div_accessibility.dart';
import 'div_action.dart';
import 'div_alignment_horizontal.dart';
import 'div_alignment_vertical.dart';
import 'div_appearance_transition.dart';
import 'div_background.dart';
import 'div_base.dart';
import 'div_border.dart';
import 'div_change_transition.dart';
import 'div_disappear_action.dart';
import 'div_drawable.dart';
import 'div_edge_insets.dart';
import 'div_extension.dart';
import 'div_focus.dart';
import 'div_font_weight.dart';
import 'div_match_parent_size.dart';
import 'div_point.dart';
import 'div_size.dart';
import 'div_size_unit.dart';
import 'div_tooltip.dart';
import 'div_transform.dart';
import 'div_transition_trigger.dart';
import 'div_visibility.dart';
import 'div_visibility_action.dart';
import 'div_wrap_content_size.dart';

class DivSlider with EquatableMixin implements DivBase {
  const DivSlider({
    this.accessibility = const DivAccessibility(),
    this.alignmentHorizontal,
    this.alignmentVertical,
    this.alpha = const ValueExpression(1.0),
    this.background,
    this.border = const DivBorder(),
    this.columnSpan,
    this.disappearActions,
    this.extensions,
    this.focus,
    this.height = const DivSize(DivWrapContentSize()),
    this.id,
    this.margins = const DivEdgeInsets(),
    this.maxValue = const ValueExpression(100),
    this.minValue = const ValueExpression(0),
    this.paddings = const DivEdgeInsets(),
    this.ranges,
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
    this.visibility = const ValueExpression(DivVisibility.visible),
    this.visibilityAction,
    this.visibilityActions,
    this.width = const DivSize(DivMatchParentSize()),
  });

  static const type = "slider";

  @override
  final DivAccessibility accessibility;

  @override
  final Expression<DivAlignmentHorizontal>? alignmentHorizontal;

  @override
  final Expression<DivAlignmentVertical>? alignmentVertical;
  // constraint: number >= 0.0 && number <= 1.0; default value: 1.0
  @override
  final Expression<double> alpha;

  @override
  final List<DivBackground>? background;

  @override
  final DivBorder border;
  // constraint: number >= 0
  @override
  final Expression<int>? columnSpan;

  @override
  final List<DivDisappearAction>? disappearActions;

  @override
  final List<DivExtension>? extensions;

  @override
  final DivFocus? focus;
  // default value: const DivSize(DivWrapContentSize())
  @override
  final DivSize height;

  @override
  final String? id;

  @override
  final DivEdgeInsets margins;
  // default value: 100
  final Expression<int> maxValue;
  // default value: 0
  final Expression<int> minValue;

  @override
  final DivEdgeInsets paddings;

  final List<DivSliderRange>? ranges;
  // constraint: number >= 0
  @override
  final Expression<int>? rowSpan;

  final DivAccessibility secondaryValueAccessibility;

  @override
  final List<DivAction>? selectedActions;

  final DivDrawable? thumbSecondaryStyle;

  final DivSliderTextStyle? thumbSecondaryTextStyle;

  final String? thumbSecondaryValueVariable;

  final DivDrawable thumbStyle;

  final DivSliderTextStyle? thumbTextStyle;

  final String? thumbValueVariable;

  final DivDrawable? tickMarkActiveStyle;

  final DivDrawable? tickMarkInactiveStyle;

  @override
  final List<DivTooltip>? tooltips;

  final DivDrawable trackActiveStyle;

  final DivDrawable trackInactiveStyle;

  @override
  final DivTransform transform;

  @override
  final DivChangeTransition? transitionChange;

  @override
  final DivAppearanceTransition? transitionIn;

  @override
  final DivAppearanceTransition? transitionOut;
  // at least 1 elements
  @override
  final List<DivTransitionTrigger>? transitionTriggers;
  // default value: DivVisibility.visible
  @override
  final Expression<DivVisibility> visibility;

  @override
  final DivVisibilityAction? visibilityAction;

  @override
  final List<DivVisibilityAction>? visibilityActions;
  // default value: const DivSize(DivMatchParentSize())
  @override
  final DivSize width;

  @override
  List<Object?> get props => [
        accessibility,
        alignmentHorizontal,
        alignmentVertical,
        alpha,
        background,
        border,
        columnSpan,
        disappearActions,
        extensions,
        focus,
        height,
        id,
        margins,
        maxValue,
        minValue,
        paddings,
        ranges,
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
        visibility,
        visibilityAction,
        visibilityActions,
        width,
      ];

  static DivSlider? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
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
      background: safeParseObj(
        (json['background'] as List<dynamic>?)
            ?.map(
              (v) => safeParseObj(
                DivBackground.fromJson(v),
              )!,
            )
            .toList(),
      ),
      border: safeParseObj(
        DivBorder.fromJson(json['border']),
        fallback: const DivBorder(),
      )!,
      columnSpan: safeParseIntExpr(
        json['column_span'],
      ),
      disappearActions: safeParseObj(
        (json['disappear_actions'] as List<dynamic>?)
            ?.map(
              (v) => safeParseObj(
                DivDisappearAction.fromJson(v),
              )!,
            )
            .toList(),
      ),
      extensions: safeParseObj(
        (json['extensions'] as List<dynamic>?)
            ?.map(
              (v) => safeParseObj(
                DivExtension.fromJson(v),
              )!,
            )
            .toList(),
      ),
      focus: safeParseObj(
        DivFocus.fromJson(json['focus']),
      ),
      height: safeParseObj(
        DivSize.fromJson(json['height']),
        fallback: const DivSize(DivWrapContentSize()),
      )!,
      id: safeParseStr(
        json['id']?.toString(),
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
        (json['ranges'] as List<dynamic>?)
            ?.map(
              (v) => safeParseObj(
                DivSliderRange.fromJson(v),
              )!,
            )
            .toList(),
      ),
      rowSpan: safeParseIntExpr(
        json['row_span'],
      ),
      secondaryValueAccessibility: safeParseObj(
        DivAccessibility.fromJson(json['secondary_value_accessibility']),
        fallback: const DivAccessibility(),
      )!,
      selectedActions: safeParseObj(
        (json['selected_actions'] as List<dynamic>?)
            ?.map(
              (v) => safeParseObj(
                DivAction.fromJson(v),
              )!,
            )
            .toList(),
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
        (json['tooltips'] as List<dynamic>?)
            ?.map(
              (v) => safeParseObj(
                DivTooltip.fromJson(v),
              )!,
            )
            .toList(),
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
        (json['transition_triggers'] as List<dynamic>?)
            ?.map(
              (v) => safeParseStrEnum(
                v,
                parse: DivTransitionTrigger.fromJson,
              )!,
            )
            .toList(),
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
        (json['visibility_actions'] as List<dynamic>?)
            ?.map(
              (v) => safeParseObj(
                DivVisibilityAction.fromJson(v),
              )!,
            )
            .toList(),
      ),
      width: safeParseObj(
        DivSize.fromJson(json['width']),
        fallback: const DivSize(DivMatchParentSize()),
      )!,
    );
  }
}

class DivSliderTextStyle with EquatableMixin {
  const DivSliderTextStyle({
    required this.fontSize,
    this.fontSizeUnit = const ValueExpression(DivSizeUnit.sp),
    this.fontWeight = const ValueExpression(DivFontWeight.regular),
    this.offset,
    this.textColor = const ValueExpression(const Color(0xFF000000)),
  });

  // constraint: number >= 0
  final Expression<int> fontSize;
  // default value: DivSizeUnit.sp
  final Expression<DivSizeUnit> fontSizeUnit;
  // default value: DivFontWeight.regular
  final Expression<DivFontWeight> fontWeight;

  final DivPoint? offset;
  // default value: const Color(0xFF000000)
  final Expression<Color> textColor;

  @override
  List<Object?> get props => [
        fontSize,
        fontSizeUnit,
        fontWeight,
        offset,
        textColor,
      ];

  static DivSliderTextStyle? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
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
      offset: safeParseObj(
        DivPoint.fromJson(json['offset']),
      ),
      textColor: safeParseColorExpr(
        json['text_color'],
        fallback: const Color(0xFF000000),
      )!,
    );
  }
}

class DivSliderRange with EquatableMixin {
  const DivSliderRange({
    this.end,
    this.margins = const DivEdgeInsets(),
    this.start,
    this.trackActiveStyle,
    this.trackInactiveStyle,
  });

  final Expression<int>? end;

  final DivEdgeInsets margins;

  final Expression<int>? start;

  final DivDrawable? trackActiveStyle;

  final DivDrawable? trackInactiveStyle;

  @override
  List<Object?> get props => [
        end,
        margins,
        start,
        trackActiveStyle,
        trackInactiveStyle,
      ];

  static DivSliderRange? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
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
  }
}
