// Generated code. Do not modify.

import 'package:divkit/src/schema/div_accessibility.dart';
import 'package:divkit/src/schema/div_action.dart';
import 'package:divkit/src/schema/div_alignment_horizontal.dart';
import 'package:divkit/src/schema/div_alignment_vertical.dart';
import 'package:divkit/src/schema/div_animator.dart';
import 'package:divkit/src/schema/div_appearance_transition.dart';
import 'package:divkit/src/schema/div_aspect.dart';
import 'package:divkit/src/schema/div_background.dart';
import 'package:divkit/src/schema/div_base.dart';
import 'package:divkit/src/schema/div_border.dart';
import 'package:divkit/src/schema/div_change_transition.dart';
import 'package:divkit/src/schema/div_disappear_action.dart';
import 'package:divkit/src/schema/div_edge_insets.dart';
import 'package:divkit/src/schema/div_extension.dart';
import 'package:divkit/src/schema/div_focus.dart';
import 'package:divkit/src/schema/div_function.dart';
import 'package:divkit/src/schema/div_layout_provider.dart';
import 'package:divkit/src/schema/div_match_parent_size.dart';
import 'package:divkit/src/schema/div_size.dart';
import 'package:divkit/src/schema/div_tooltip.dart';
import 'package:divkit/src/schema/div_transform.dart';
import 'package:divkit/src/schema/div_transition_trigger.dart';
import 'package:divkit/src/schema/div_trigger.dart';
import 'package:divkit/src/schema/div_variable.dart';
import 'package:divkit/src/schema/div_video_scale.dart';
import 'package:divkit/src/schema/div_video_source.dart';
import 'package:divkit/src/schema/div_visibility.dart';
import 'package:divkit/src/schema/div_visibility_action.dart';
import 'package:divkit/src/schema/div_wrap_content_size.dart';
import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

/// Video.
class DivVideo extends Resolvable with EquatableMixin implements DivBase {
  const DivVideo({
    this.accessibility = const DivAccessibility(),
    this.alignmentHorizontal,
    this.alignmentVertical,
    this.alpha = const ValueExpression(1.0),
    this.animators,
    this.aspect,
    this.autostart = const ValueExpression(false),
    this.background,
    this.border = const DivBorder(),
    this.bufferingActions,
    this.columnSpan,
    this.disappearActions,
    this.elapsedTimeVariable,
    this.endActions,
    this.extensions,
    this.fatalActions,
    this.focus,
    this.functions,
    this.height = const DivSize.divWrapContentSize(
      DivWrapContentSize(),
    ),
    this.id,
    this.layoutProvider,
    this.margins = const DivEdgeInsets(),
    this.muted = const ValueExpression(false),
    this.paddings = const DivEdgeInsets(),
    this.pauseActions,
    this.playerSettingsPayload,
    this.preloadRequired = const ValueExpression(false),
    this.preview,
    this.repeatable = const ValueExpression(false),
    this.resumeActions,
    this.reuseId,
    this.rowSpan,
    this.scale = const ValueExpression(DivVideoScale.fit),
    this.selectedActions,
    this.tooltips,
    this.transform = const DivTransform(),
    this.transitionChange,
    this.transitionIn,
    this.transitionOut,
    this.transitionTriggers,
    this.variableTriggers,
    this.variables,
    required this.videoSources,
    this.visibility = const ValueExpression(DivVisibility.visible),
    this.visibilityAction,
    this.visibilityActions,
    this.width = const DivSize.divMatchParentSize(
      DivMatchParentSize(),
    ),
  });

  static const type = "video";

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

  /// Fixed aspect ratio. The element's height is calculated based on the width, ignoring the `height` value.
  final DivAspect? aspect;

  /// This option turns on automatic video playback. On the web, the video starts if muted playback is turned on.
  // default value: false
  final Expression<bool> autostart;

  /// Element background. It can contain multiple layers.
  @override
  final List<DivBackground>? background;

  /// Element stroke.
  @override
  final DivBorder border;

  /// Actions performed during video loading.
  final List<DivAction>? bufferingActions;

  /// Merges cells in a column of the [grid](div-grid.md) element.
  // constraint: number >= 0
  @override
  final Expression<int>? columnSpan;

  /// Actions when an element disappears from the screen.
  @override
  final List<DivDisappearAction>? disappearActions;

  /// Time interval from the video beginning to the current position in milliseconds.
  final String? elapsedTimeVariable;

  /// Actions performed after the video ends.
  final List<DivAction>? endActions;

  /// Extensions for additional processing of an element. The list of extensions is given in  [DivExtension](https://divkit.tech/docs/en/concepts/extensions).
  @override
  final List<DivExtension>? extensions;

  /// Actions performed when playback can't be continued due to a player error.
  final List<DivAction>? fatalActions;

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

  /// This option mutes video.
  // default value: false
  final Expression<bool> muted;

  /// Internal margins from the element stroke.
  @override
  final DivEdgeInsets paddings;

  /// Actions performed when playback is paused.
  final List<DivAction>? pauseActions;

  /// Additional information that can be used in the player.
  final Map<String, dynamic>? playerSettingsPayload;

  /// Enables video preloading.
  // default value: false
  final Expression<bool> preloadRequired;

  /// Video preview encoded in `base64`. Will be shown until the video is ready to play. `Data url` format: `data:[;base64],<data>`
  final Expression<String>? preview;

  /// This option turns on video repeat.
  // default value: false
  final Expression<bool> repeatable;

  /// Actions performed when video playback resumes.
  final List<DivAction>? resumeActions;

  /// ID for the div object structure. Used to optimize block reuse. See [block reuse](https://divkit.tech/docs/en/concepts/reuse/reuse.md).
  @override
  final Expression<String>? reuseId;

  /// Merges cells in a string of the [grid](div-grid.md) element.
  // constraint: number >= 0
  @override
  final Expression<int>? rowSpan;

  /// Video scaling:
  /// • `fit` places the entire video into the element (free space is filled with background);
  /// • `fill` scales the video to the element size and cuts off anything that's extra.
  // default value: DivVideoScale.fit
  final Expression<DivVideoScale> scale;

  /// List of [actions](div-action.md) to be executed when selecting an element in [pager](div-pager.md).
  @override
  final List<DivAction>? selectedActions;

  /// Tooltips linked to an element. A tooltip can be shown by `div-action://show_tooltip?id=`, hidden by `div-action://hide_tooltip?id=` where `id` — tooltip id.
  @override
  final List<DivTooltip>? tooltips;

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
  // at least 1 elements
  final List<DivVideoSource> videoSources;

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
        aspect,
        autostart,
        background,
        border,
        bufferingActions,
        columnSpan,
        disappearActions,
        elapsedTimeVariable,
        endActions,
        extensions,
        fatalActions,
        focus,
        functions,
        height,
        id,
        layoutProvider,
        margins,
        muted,
        paddings,
        pauseActions,
        playerSettingsPayload,
        preloadRequired,
        preview,
        repeatable,
        resumeActions,
        reuseId,
        rowSpan,
        scale,
        selectedActions,
        tooltips,
        transform,
        transitionChange,
        transitionIn,
        transitionOut,
        transitionTriggers,
        variableTriggers,
        variables,
        videoSources,
        visibility,
        visibilityAction,
        visibilityActions,
        width,
      ];

  DivVideo copyWith({
    DivAccessibility? accessibility,
    Expression<DivAlignmentHorizontal>? Function()? alignmentHorizontal,
    Expression<DivAlignmentVertical>? Function()? alignmentVertical,
    Expression<double>? alpha,
    List<DivAnimator>? Function()? animators,
    DivAspect? Function()? aspect,
    Expression<bool>? autostart,
    List<DivBackground>? Function()? background,
    DivBorder? border,
    List<DivAction>? Function()? bufferingActions,
    Expression<int>? Function()? columnSpan,
    List<DivDisappearAction>? Function()? disappearActions,
    String? Function()? elapsedTimeVariable,
    List<DivAction>? Function()? endActions,
    List<DivExtension>? Function()? extensions,
    List<DivAction>? Function()? fatalActions,
    DivFocus? Function()? focus,
    List<DivFunction>? Function()? functions,
    DivSize? height,
    String? Function()? id,
    DivLayoutProvider? Function()? layoutProvider,
    DivEdgeInsets? margins,
    Expression<bool>? muted,
    DivEdgeInsets? paddings,
    List<DivAction>? Function()? pauseActions,
    Map<String, dynamic>? Function()? playerSettingsPayload,
    Expression<bool>? preloadRequired,
    Expression<String>? Function()? preview,
    Expression<bool>? repeatable,
    List<DivAction>? Function()? resumeActions,
    Expression<String>? Function()? reuseId,
    Expression<int>? Function()? rowSpan,
    Expression<DivVideoScale>? scale,
    List<DivAction>? Function()? selectedActions,
    List<DivTooltip>? Function()? tooltips,
    DivTransform? transform,
    DivChangeTransition? Function()? transitionChange,
    DivAppearanceTransition? Function()? transitionIn,
    DivAppearanceTransition? Function()? transitionOut,
    List<DivTransitionTrigger>? Function()? transitionTriggers,
    List<DivTrigger>? Function()? variableTriggers,
    List<DivVariable>? Function()? variables,
    List<DivVideoSource>? videoSources,
    Expression<DivVisibility>? visibility,
    DivVisibilityAction? Function()? visibilityAction,
    List<DivVisibilityAction>? Function()? visibilityActions,
    DivSize? width,
  }) =>
      DivVideo(
        accessibility: accessibility ?? this.accessibility,
        alignmentHorizontal: alignmentHorizontal != null
            ? alignmentHorizontal.call()
            : this.alignmentHorizontal,
        alignmentVertical: alignmentVertical != null
            ? alignmentVertical.call()
            : this.alignmentVertical,
        alpha: alpha ?? this.alpha,
        animators: animators != null ? animators.call() : this.animators,
        aspect: aspect != null ? aspect.call() : this.aspect,
        autostart: autostart ?? this.autostart,
        background: background != null ? background.call() : this.background,
        border: border ?? this.border,
        bufferingActions: bufferingActions != null
            ? bufferingActions.call()
            : this.bufferingActions,
        columnSpan: columnSpan != null ? columnSpan.call() : this.columnSpan,
        disappearActions: disappearActions != null
            ? disappearActions.call()
            : this.disappearActions,
        elapsedTimeVariable: elapsedTimeVariable != null
            ? elapsedTimeVariable.call()
            : this.elapsedTimeVariable,
        endActions: endActions != null ? endActions.call() : this.endActions,
        extensions: extensions != null ? extensions.call() : this.extensions,
        fatalActions:
            fatalActions != null ? fatalActions.call() : this.fatalActions,
        focus: focus != null ? focus.call() : this.focus,
        functions: functions != null ? functions.call() : this.functions,
        height: height ?? this.height,
        id: id != null ? id.call() : this.id,
        layoutProvider: layoutProvider != null
            ? layoutProvider.call()
            : this.layoutProvider,
        margins: margins ?? this.margins,
        muted: muted ?? this.muted,
        paddings: paddings ?? this.paddings,
        pauseActions:
            pauseActions != null ? pauseActions.call() : this.pauseActions,
        playerSettingsPayload: playerSettingsPayload != null
            ? playerSettingsPayload.call()
            : this.playerSettingsPayload,
        preloadRequired: preloadRequired ?? this.preloadRequired,
        preview: preview != null ? preview.call() : this.preview,
        repeatable: repeatable ?? this.repeatable,
        resumeActions:
            resumeActions != null ? resumeActions.call() : this.resumeActions,
        reuseId: reuseId != null ? reuseId.call() : this.reuseId,
        rowSpan: rowSpan != null ? rowSpan.call() : this.rowSpan,
        scale: scale ?? this.scale,
        selectedActions: selectedActions != null
            ? selectedActions.call()
            : this.selectedActions,
        tooltips: tooltips != null ? tooltips.call() : this.tooltips,
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
        videoSources: videoSources ?? this.videoSources,
        visibility: visibility ?? this.visibility,
        visibilityAction: visibilityAction != null
            ? visibilityAction.call()
            : this.visibilityAction,
        visibilityActions: visibilityActions != null
            ? visibilityActions.call()
            : this.visibilityActions,
        width: width ?? this.width,
      );

  static DivVideo? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivVideo(
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
        aspect: safeParseObj(
          DivAspect.fromJson(json['aspect']),
        ),
        autostart: safeParseBoolExpr(
          json['autostart'],
          fallback: false,
        )!,
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
        bufferingActions: safeParseObj(
          safeListMap(
            json['buffering_actions'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
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
        elapsedTimeVariable: safeParseStr(
          json['elapsed_time_variable']?.toString(),
        ),
        endActions: safeParseObj(
          safeListMap(
            json['end_actions'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
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
        fatalActions: safeParseObj(
          safeListMap(
            json['fatal_actions'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
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
        muted: safeParseBoolExpr(
          json['muted'],
          fallback: false,
        )!,
        paddings: safeParseObj(
          DivEdgeInsets.fromJson(json['paddings']),
          fallback: const DivEdgeInsets(),
        )!,
        pauseActions: safeParseObj(
          safeListMap(
            json['pause_actions'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
        playerSettingsPayload: safeParseMap(
          json['player_settings_payload'],
        ),
        preloadRequired: safeParseBoolExpr(
          json['preload_required'],
          fallback: false,
        )!,
        preview: safeParseStrExpr(
          json['preview']?.toString(),
        ),
        repeatable: safeParseBoolExpr(
          json['repeatable'],
          fallback: false,
        )!,
        resumeActions: safeParseObj(
          safeListMap(
            json['resume_actions'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
        reuseId: safeParseStrExpr(
          json['reuse_id']?.toString(),
        ),
        rowSpan: safeParseIntExpr(
          json['row_span'],
        ),
        scale: safeParseStrEnumExpr(
          json['scale'],
          parse: DivVideoScale.fromJson,
          fallback: DivVideoScale.fit,
        )!,
        selectedActions: safeParseObj(
          safeListMap(
            json['selected_actions'],
            (v) => safeParseObj(
              DivAction.fromJson(v),
            )!,
          ),
        ),
        tooltips: safeParseObj(
          safeListMap(
            json['tooltips'],
            (v) => safeParseObj(
              DivTooltip.fromJson(v),
            )!,
          ),
        ),
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
        videoSources: safeParseObj(
          safeListMap(
            json['video_sources'],
            (v) => safeParseObj(
              DivVideoSource.fromJson(v),
            )!,
          ),
        )!,
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
  DivVideo resolve(DivVariableContext context) {
    accessibility.resolve(context);
    alignmentHorizontal?.resolve(context);
    alignmentVertical?.resolve(context);
    alpha.resolve(context);
    safeListResolve(animators, (v) => v.resolve(context));
    aspect?.resolve(context);
    autostart.resolve(context);
    safeListResolve(background, (v) => v.resolve(context));
    border.resolve(context);
    safeListResolve(bufferingActions, (v) => v.resolve(context));
    columnSpan?.resolve(context);
    safeListResolve(disappearActions, (v) => v.resolve(context));
    safeListResolve(endActions, (v) => v.resolve(context));
    safeListResolve(extensions, (v) => v.resolve(context));
    safeListResolve(fatalActions, (v) => v.resolve(context));
    focus?.resolve(context);
    safeListResolve(functions, (v) => v.resolve(context));
    height.resolve(context);
    layoutProvider?.resolve(context);
    margins.resolve(context);
    muted.resolve(context);
    paddings.resolve(context);
    safeListResolve(pauseActions, (v) => v.resolve(context));
    preloadRequired.resolve(context);
    preview?.resolve(context);
    repeatable.resolve(context);
    safeListResolve(resumeActions, (v) => v.resolve(context));
    reuseId?.resolve(context);
    rowSpan?.resolve(context);
    scale.resolve(context);
    safeListResolve(selectedActions, (v) => v.resolve(context));
    safeListResolve(tooltips, (v) => v.resolve(context));
    transform.resolve(context);
    transitionChange?.resolve(context);
    transitionIn?.resolve(context);
    transitionOut?.resolve(context);
    safeListResolve(transitionTriggers, (v) => v.resolve(context));
    safeListResolve(variableTriggers, (v) => v.resolve(context));
    safeListResolve(variables, (v) => v.resolve(context));
    safeListResolve(videoSources, (v) => v.resolve(context));
    visibility.resolve(context);
    visibilityAction?.resolve(context);
    safeListResolve(visibilityActions, (v) => v.resolve(context));
    width.resolve(context);
    return this;
  }
}
