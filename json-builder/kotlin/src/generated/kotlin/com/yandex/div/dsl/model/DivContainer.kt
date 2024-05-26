// Generated code. Do not modify.

package com.yandex.div.dsl.model

import java.net.URI
import com.fasterxml.jackson.annotation.*
import com.yandex.div.dsl.*
import com.yandex.div.dsl.context.*
import com.yandex.div.dsl.type.*
import com.yandex.div.dsl.util.*

class DivContainer internal constructor(
    @JsonIgnore override val accessibility: Property<DivAccessibility>?,
    @JsonIgnore val action: Property<DivAction>?,
    @JsonIgnore val actionAnimation: Property<DivAnimation>?,
    @JsonIgnore val actions: Property<List<DivAction>>?,
    @JsonIgnore override val alignmentHorizontal: Property<DivAlignmentHorizontal>?,
    @JsonIgnore override val alignmentVertical: Property<DivAlignmentVertical>?,
    @JsonIgnore override val alpha: Property<Double>?,
    @JsonIgnore override val background: Property<List<DivBackground>>?,
    @JsonIgnore override val border: Property<DivBorder>?,
    @JsonIgnore override val columnSpan: Property<Int>?,
    @JsonIgnore val contentAlignmentHorizontal: Property<DivAlignmentHorizontal>?,
    @JsonIgnore val contentAlignmentVertical: Property<DivAlignmentVertical>?,
    @JsonIgnore val doubletapActions: Property<List<DivAction>>?,
    @JsonIgnore override val extensions: Property<List<DivExtension>>?,
    @JsonIgnore override val focus: Property<DivFocus>?,
    @JsonIgnore override val height: Property<DivSize>?,
    @JsonIgnore override val id: Property<String>?,
    @JsonIgnore val items: Property<List<Div>>?,
    @JsonIgnore val layoutMode: Property<LayoutMode>?,
    @JsonIgnore val lineSeparator: Property<Separator>?,
    @JsonIgnore val longtapActions: Property<List<DivAction>>?,
    @JsonIgnore override val margins: Property<DivEdgeInsets>?,
    @JsonIgnore val orientation: Property<Orientation>?,
    @JsonIgnore override val paddings: Property<DivEdgeInsets>?,
    @JsonIgnore override val rowSpan: Property<Int>?,
    @JsonIgnore override val selectedActions: Property<List<DivAction>>?,
    @JsonIgnore val separator: Property<Separator>?,
    @JsonIgnore override val tooltips: Property<List<DivTooltip>>?,
    @JsonIgnore override val transform: Property<DivTransform>?,
    @JsonIgnore override val transitionChange: Property<DivChangeTransition>?,
    @JsonIgnore override val transitionIn: Property<DivAppearanceTransition>?,
    @JsonIgnore override val transitionOut: Property<DivAppearanceTransition>?,
    @JsonIgnore override val transitionTriggers: Property<List<DivTransitionTrigger>>?,
    @JsonIgnore override val visibility: Property<DivVisibility>?,
    @JsonIgnore override val visibilityAction: Property<DivVisibilityAction>?,
    @JsonIgnore override val visibilityActions: Property<List<DivVisibilityAction>>?,
    @JsonIgnore override val width: Property<DivSize>?,
) : Div, DivBase {

    @JsonProperty("type") override val type = "container"

    @JsonAnyGetter
    internal fun properties(): Map<String, Any> {
        return propertyMapOf(
            "accessibility" to accessibility,
            "action" to action,
            "action_animation" to actionAnimation,
            "actions" to actions,
            "alignment_horizontal" to alignmentHorizontal,
            "alignment_vertical" to alignmentVertical,
            "alpha" to alpha,
            "background" to background,
            "border" to border,
            "column_span" to columnSpan,
            "content_alignment_horizontal" to contentAlignmentHorizontal,
            "content_alignment_vertical" to contentAlignmentVertical,
            "doubletap_actions" to doubletapActions,
            "extensions" to extensions,
            "focus" to focus,
            "height" to height,
            "id" to id,
            "items" to items,
            "layout_mode" to layoutMode,
            "line_separator" to lineSeparator,
            "longtap_actions" to longtapActions,
            "margins" to margins,
            "orientation" to orientation,
            "paddings" to paddings,
            "row_span" to rowSpan,
            "selected_actions" to selectedActions,
            "separator" to separator,
            "tooltips" to tooltips,
            "transform" to transform,
            "transition_change" to transitionChange,
            "transition_in" to transitionIn,
            "transition_out" to transitionOut,
            "transition_triggers" to transitionTriggers,
            "visibility" to visibility,
            "visibility_action" to visibilityAction,
            "visibility_actions" to visibilityActions,
            "width" to width,
        )
    }

    enum class LayoutMode(@JsonValue val value: String) {
        NO_WRAP("no_wrap"),
        WRAP("wrap"),
    }

    enum class Orientation(@JsonValue val value: String) {
        VERTICAL("vertical"),
        HORIZONTAL("horizontal"),
        OVERLAP("overlap"),
    }

    class Separator internal constructor(
        @JsonIgnore val showAtEnd: Property<BoolInt>?,
        @JsonIgnore val showAtStart: Property<BoolInt>?,
        @JsonIgnore val showBetween: Property<BoolInt>?,
        @JsonIgnore val style: Property<DivDrawable>?,
    ) {

        @JsonAnyGetter
        internal fun properties(): Map<String, Any> {
            return propertyMapOf(
                "show_at_end" to showAtEnd,
                "show_at_start" to showAtStart,
                "show_between" to showBetween,
                "style" to style,
            )
        }
    }
}

fun <T> TemplateContext<T>.divContainer(): LiteralProperty<DivContainer> {
    return value(DivContainer(
        accessibility = null,
        action = null,
        actionAnimation = null,
        actions = null,
        alignmentHorizontal = null,
        alignmentVertical = null,
        alpha = null,
        background = null,
        border = null,
        columnSpan = null,
        contentAlignmentHorizontal = null,
        contentAlignmentVertical = null,
        doubletapActions = null,
        extensions = null,
        focus = null,
        height = null,
        id = null,
        items = null,
        layoutMode = null,
        lineSeparator = null,
        longtapActions = null,
        margins = null,
        orientation = null,
        paddings = null,
        rowSpan = null,
        selectedActions = null,
        separator = null,
        tooltips = null,
        transform = null,
        transitionChange = null,
        transitionIn = null,
        transitionOut = null,
        transitionTriggers = null,
        visibility = null,
        visibilityAction = null,
        visibilityActions = null,
        width = null,
    ))
}

fun <T> TemplateContext<T>.divContainer(
    items: Property<List<Div>>? = null,
    accessibility: Property<DivAccessibility>? = null,
    action: Property<DivAction>? = null,
    actionAnimation: Property<DivAnimation>? = null,
    actions: Property<List<DivAction>>? = null,
    alignmentHorizontal: Property<DivAlignmentHorizontal>? = null,
    alignmentVertical: Property<DivAlignmentVertical>? = null,
    alpha: Property<Double>? = null,
    background: Property<List<DivBackground>>? = null,
    border: Property<DivBorder>? = null,
    columnSpan: Property<Int>? = null,
    contentAlignmentHorizontal: Property<DivAlignmentHorizontal>? = null,
    contentAlignmentVertical: Property<DivAlignmentVertical>? = null,
    doubletapActions: Property<List<DivAction>>? = null,
    extensions: Property<List<DivExtension>>? = null,
    focus: Property<DivFocus>? = null,
    height: Property<DivSize>? = null,
    id: Property<String>? = null,
    layoutMode: Property<DivContainer.LayoutMode>? = null,
    lineSeparator: Property<DivContainer.Separator>? = null,
    longtapActions: Property<List<DivAction>>? = null,
    margins: Property<DivEdgeInsets>? = null,
    orientation: Property<DivContainer.Orientation>? = null,
    paddings: Property<DivEdgeInsets>? = null,
    rowSpan: Property<Int>? = null,
    selectedActions: Property<List<DivAction>>? = null,
    separator: Property<DivContainer.Separator>? = null,
    tooltips: Property<List<DivTooltip>>? = null,
    transform: Property<DivTransform>? = null,
    transitionChange: Property<DivChangeTransition>? = null,
    transitionIn: Property<DivAppearanceTransition>? = null,
    transitionOut: Property<DivAppearanceTransition>? = null,
    transitionTriggers: Property<List<DivTransitionTrigger>>? = null,
    visibility: Property<DivVisibility>? = null,
    visibilityAction: Property<DivVisibilityAction>? = null,
    visibilityActions: Property<List<DivVisibilityAction>>? = null,
    width: Property<DivSize>? = null,
): LiteralProperty<DivContainer> {
    return value(DivContainer(
        accessibility = accessibility,
        action = action,
        actionAnimation = actionAnimation,
        actions = actions,
        alignmentHorizontal = alignmentHorizontal,
        alignmentVertical = alignmentVertical,
        alpha = alpha,
        background = background,
        border = border,
        columnSpan = columnSpan,
        contentAlignmentHorizontal = contentAlignmentHorizontal,
        contentAlignmentVertical = contentAlignmentVertical,
        doubletapActions = doubletapActions,
        extensions = extensions,
        focus = focus,
        height = height,
        id = id,
        items = items,
        layoutMode = layoutMode,
        lineSeparator = lineSeparator,
        longtapActions = longtapActions,
        margins = margins,
        orientation = orientation,
        paddings = paddings,
        rowSpan = rowSpan,
        selectedActions = selectedActions,
        separator = separator,
        tooltips = tooltips,
        transform = transform,
        transitionChange = transitionChange,
        transitionIn = transitionIn,
        transitionOut = transitionOut,
        transitionTriggers = transitionTriggers,
        visibility = visibility,
        visibilityAction = visibilityAction,
        visibilityActions = visibilityActions,
        width = width,
    ))
}

fun <T> TemplateContext<T>.divContainer(
    items: List<Div>? = null,
    accessibility: DivAccessibility? = null,
    action: DivAction? = null,
    actionAnimation: DivAnimation? = null,
    actions: List<DivAction>? = null,
    alignmentHorizontal: DivAlignmentHorizontal? = null,
    alignmentVertical: DivAlignmentVertical? = null,
    alpha: Double? = null,
    background: List<DivBackground>? = null,
    border: DivBorder? = null,
    columnSpan: Int? = null,
    contentAlignmentHorizontal: DivAlignmentHorizontal? = null,
    contentAlignmentVertical: DivAlignmentVertical? = null,
    doubletapActions: List<DivAction>? = null,
    extensions: List<DivExtension>? = null,
    focus: DivFocus? = null,
    height: DivSize? = null,
    id: String? = null,
    layoutMode: DivContainer.LayoutMode? = null,
    lineSeparator: DivContainer.Separator? = null,
    longtapActions: List<DivAction>? = null,
    margins: DivEdgeInsets? = null,
    orientation: DivContainer.Orientation? = null,
    paddings: DivEdgeInsets? = null,
    rowSpan: Int? = null,
    selectedActions: List<DivAction>? = null,
    separator: DivContainer.Separator? = null,
    tooltips: List<DivTooltip>? = null,
    transform: DivTransform? = null,
    transitionChange: DivChangeTransition? = null,
    transitionIn: DivAppearanceTransition? = null,
    transitionOut: DivAppearanceTransition? = null,
    transitionTriggers: List<DivTransitionTrigger>? = null,
    visibility: DivVisibility? = null,
    visibilityAction: DivVisibilityAction? = null,
    visibilityActions: List<DivVisibilityAction>? = null,
    width: DivSize? = null,
): LiteralProperty<DivContainer> {
    return value(DivContainer(
        accessibility = optionalValue(accessibility),
        action = optionalValue(action),
        actionAnimation = optionalValue(actionAnimation),
        actions = optionalValue(actions),
        alignmentHorizontal = optionalValue(alignmentHorizontal),
        alignmentVertical = optionalValue(alignmentVertical),
        alpha = optionalValue(alpha),
        background = optionalValue(background),
        border = optionalValue(border),
        columnSpan = optionalValue(columnSpan),
        contentAlignmentHorizontal = optionalValue(contentAlignmentHorizontal),
        contentAlignmentVertical = optionalValue(contentAlignmentVertical),
        doubletapActions = optionalValue(doubletapActions),
        extensions = optionalValue(extensions),
        focus = optionalValue(focus),
        height = optionalValue(height),
        id = optionalValue(id),
        items = optionalValue(items),
        layoutMode = optionalValue(layoutMode),
        lineSeparator = optionalValue(lineSeparator),
        longtapActions = optionalValue(longtapActions),
        margins = optionalValue(margins),
        orientation = optionalValue(orientation),
        paddings = optionalValue(paddings),
        rowSpan = optionalValue(rowSpan),
        selectedActions = optionalValue(selectedActions),
        separator = optionalValue(separator),
        tooltips = optionalValue(tooltips),
        transform = optionalValue(transform),
        transitionChange = optionalValue(transitionChange),
        transitionIn = optionalValue(transitionIn),
        transitionOut = optionalValue(transitionOut),
        transitionTriggers = optionalValue(transitionTriggers),
        visibility = optionalValue(visibility),
        visibilityAction = optionalValue(visibilityAction),
        visibilityActions = optionalValue(visibilityActions),
        width = optionalValue(width),
    ))
}

fun <T> TemplateContext<T>.separator(): LiteralProperty<DivContainer.Separator> {
    return value(DivContainer.Separator(
        showAtEnd = null,
        showAtStart = null,
        showBetween = null,
        style = null,
    ))
}

fun <T> TemplateContext<T>.separator(
    style: Property<DivDrawable>? = null,
    showAtEnd: Property<BoolInt>? = null,
    showAtStart: Property<BoolInt>? = null,
    showBetween: Property<BoolInt>? = null,
): LiteralProperty<DivContainer.Separator> {
    return value(DivContainer.Separator(
        showAtEnd = showAtEnd,
        showAtStart = showAtStart,
        showBetween = showBetween,
        style = style,
    ))
}

fun <T> TemplateContext<T>.separator(
    style: DivDrawable? = null,
    showAtEnd: BoolInt? = null,
    showAtStart: BoolInt? = null,
    showBetween: BoolInt? = null,
): LiteralProperty<DivContainer.Separator> {
    return value(DivContainer.Separator(
        showAtEnd = optionalValue(showAtEnd),
        showAtStart = optionalValue(showAtStart),
        showBetween = optionalValue(showBetween),
        style = optionalValue(style),
    ))
}

fun CardContext.divContainer(
    items: ValueProperty<List<Div>>,
    accessibility: ValueProperty<DivAccessibility>? = null,
    action: ValueProperty<DivAction>? = null,
    actionAnimation: ValueProperty<DivAnimation>? = null,
    actions: ValueProperty<List<DivAction>>? = null,
    alignmentHorizontal: ValueProperty<DivAlignmentHorizontal>? = null,
    alignmentVertical: ValueProperty<DivAlignmentVertical>? = null,
    alpha: ValueProperty<Double>? = null,
    background: ValueProperty<List<DivBackground>>? = null,
    border: ValueProperty<DivBorder>? = null,
    columnSpan: ValueProperty<Int>? = null,
    contentAlignmentHorizontal: ValueProperty<DivAlignmentHorizontal>? = null,
    contentAlignmentVertical: ValueProperty<DivAlignmentVertical>? = null,
    doubletapActions: ValueProperty<List<DivAction>>? = null,
    extensions: ValueProperty<List<DivExtension>>? = null,
    focus: ValueProperty<DivFocus>? = null,
    height: ValueProperty<DivSize>? = null,
    id: ValueProperty<String>? = null,
    layoutMode: ValueProperty<DivContainer.LayoutMode>? = null,
    lineSeparator: ValueProperty<DivContainer.Separator>? = null,
    longtapActions: ValueProperty<List<DivAction>>? = null,
    margins: ValueProperty<DivEdgeInsets>? = null,
    orientation: ValueProperty<DivContainer.Orientation>? = null,
    paddings: ValueProperty<DivEdgeInsets>? = null,
    rowSpan: ValueProperty<Int>? = null,
    selectedActions: ValueProperty<List<DivAction>>? = null,
    separator: ValueProperty<DivContainer.Separator>? = null,
    tooltips: ValueProperty<List<DivTooltip>>? = null,
    transform: ValueProperty<DivTransform>? = null,
    transitionChange: ValueProperty<DivChangeTransition>? = null,
    transitionIn: ValueProperty<DivAppearanceTransition>? = null,
    transitionOut: ValueProperty<DivAppearanceTransition>? = null,
    transitionTriggers: ValueProperty<List<DivTransitionTrigger>>? = null,
    visibility: ValueProperty<DivVisibility>? = null,
    visibilityAction: ValueProperty<DivVisibilityAction>? = null,
    visibilityActions: ValueProperty<List<DivVisibilityAction>>? = null,
    width: ValueProperty<DivSize>? = null,
): DivContainer {
    return DivContainer(
        accessibility = accessibility,
        action = action,
        actionAnimation = actionAnimation,
        actions = actions,
        alignmentHorizontal = alignmentHorizontal,
        alignmentVertical = alignmentVertical,
        alpha = alpha,
        background = background,
        border = border,
        columnSpan = columnSpan,
        contentAlignmentHorizontal = contentAlignmentHorizontal,
        contentAlignmentVertical = contentAlignmentVertical,
        doubletapActions = doubletapActions,
        extensions = extensions,
        focus = focus,
        height = height,
        id = id,
        items = items,
        layoutMode = layoutMode,
        lineSeparator = lineSeparator,
        longtapActions = longtapActions,
        margins = margins,
        orientation = orientation,
        paddings = paddings,
        rowSpan = rowSpan,
        selectedActions = selectedActions,
        separator = separator,
        tooltips = tooltips,
        transform = transform,
        transitionChange = transitionChange,
        transitionIn = transitionIn,
        transitionOut = transitionOut,
        transitionTriggers = transitionTriggers,
        visibility = visibility,
        visibilityAction = visibilityAction,
        visibilityActions = visibilityActions,
        width = width,
    )
}

fun CardContext.divContainer(
    items: List<Div>,
    accessibility: DivAccessibility? = null,
    action: DivAction? = null,
    actionAnimation: DivAnimation? = null,
    actions: List<DivAction>? = null,
    alignmentHorizontal: DivAlignmentHorizontal? = null,
    alignmentVertical: DivAlignmentVertical? = null,
    alpha: Double? = null,
    background: List<DivBackground>? = null,
    border: DivBorder? = null,
    columnSpan: Int? = null,
    contentAlignmentHorizontal: DivAlignmentHorizontal? = null,
    contentAlignmentVertical: DivAlignmentVertical? = null,
    doubletapActions: List<DivAction>? = null,
    extensions: List<DivExtension>? = null,
    focus: DivFocus? = null,
    height: DivSize? = null,
    id: String? = null,
    layoutMode: DivContainer.LayoutMode? = null,
    lineSeparator: DivContainer.Separator? = null,
    longtapActions: List<DivAction>? = null,
    margins: DivEdgeInsets? = null,
    orientation: DivContainer.Orientation? = null,
    paddings: DivEdgeInsets? = null,
    rowSpan: Int? = null,
    selectedActions: List<DivAction>? = null,
    separator: DivContainer.Separator? = null,
    tooltips: List<DivTooltip>? = null,
    transform: DivTransform? = null,
    transitionChange: DivChangeTransition? = null,
    transitionIn: DivAppearanceTransition? = null,
    transitionOut: DivAppearanceTransition? = null,
    transitionTriggers: List<DivTransitionTrigger>? = null,
    visibility: DivVisibility? = null,
    visibilityAction: DivVisibilityAction? = null,
    visibilityActions: List<DivVisibilityAction>? = null,
    width: DivSize? = null,
): DivContainer {
    return DivContainer(
        accessibility = optionalValue(accessibility),
        action = optionalValue(action),
        actionAnimation = optionalValue(actionAnimation),
        actions = optionalValue(actions),
        alignmentHorizontal = optionalValue(alignmentHorizontal),
        alignmentVertical = optionalValue(alignmentVertical),
        alpha = optionalValue(alpha),
        background = optionalValue(background),
        border = optionalValue(border),
        columnSpan = optionalValue(columnSpan),
        contentAlignmentHorizontal = optionalValue(contentAlignmentHorizontal),
        contentAlignmentVertical = optionalValue(contentAlignmentVertical),
        doubletapActions = optionalValue(doubletapActions),
        extensions = optionalValue(extensions),
        focus = optionalValue(focus),
        height = optionalValue(height),
        id = optionalValue(id),
        items = value(items),
        layoutMode = optionalValue(layoutMode),
        lineSeparator = optionalValue(lineSeparator),
        longtapActions = optionalValue(longtapActions),
        margins = optionalValue(margins),
        orientation = optionalValue(orientation),
        paddings = optionalValue(paddings),
        rowSpan = optionalValue(rowSpan),
        selectedActions = optionalValue(selectedActions),
        separator = optionalValue(separator),
        tooltips = optionalValue(tooltips),
        transform = optionalValue(transform),
        transitionChange = optionalValue(transitionChange),
        transitionIn = optionalValue(transitionIn),
        transitionOut = optionalValue(transitionOut),
        transitionTriggers = optionalValue(transitionTriggers),
        visibility = optionalValue(visibility),
        visibilityAction = optionalValue(visibilityAction),
        visibilityActions = optionalValue(visibilityActions),
        width = optionalValue(width),
    )
}

fun CardContext.separator(
    style: ValueProperty<DivDrawable>,
    showAtEnd: ValueProperty<BoolInt>? = null,
    showAtStart: ValueProperty<BoolInt>? = null,
    showBetween: ValueProperty<BoolInt>? = null,
): DivContainer.Separator {
    return DivContainer.Separator(
        showAtEnd = showAtEnd,
        showAtStart = showAtStart,
        showBetween = showBetween,
        style = style,
    )
}

fun CardContext.separator(
    style: DivDrawable,
    showAtEnd: BoolInt? = null,
    showAtStart: BoolInt? = null,
    showBetween: BoolInt? = null,
): DivContainer.Separator {
    return DivContainer.Separator(
        showAtEnd = optionalValue(showAtEnd),
        showAtStart = optionalValue(showAtStart),
        showBetween = optionalValue(showBetween),
        style = value(style),
    )
}
