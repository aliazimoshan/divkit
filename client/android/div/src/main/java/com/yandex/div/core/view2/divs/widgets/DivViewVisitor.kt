package com.yandex.div.core.view2.divs.widgets

import android.view.View
import android.view.ViewGroup
import androidx.core.view.children

internal abstract class DivViewVisitor {
    open fun defaultVisit(view: DivHolderView<*>) = Unit
    open fun visit(view: DivWrapLayout) = defaultVisit(view)
    open fun visit(view: DivFrameLayout) = defaultVisit(view)
    open fun visit(view: DivGifImageView) = defaultVisit(view)
    open fun visit(view: DivGridLayout) = defaultVisit(view)
    open fun visit(view: DivImageView) = defaultVisit(view)
    open fun visit(view: DivLinearLayout) = defaultVisit(view)
    open fun visit(view: DivLineHeightTextView) = defaultVisit(view)
    open fun visit(view: DivPagerIndicatorView) = defaultVisit(view)
    open fun visit(view: DivPagerView) = defaultVisit(view)
    open fun visit(view: DivRecyclerView) = defaultVisit(view)
    open fun visit(view: DivSeparatorView) = defaultVisit(view)
    open fun visit(view: DivStateLayout) = defaultVisit(view)
    open fun visit(view: DivTabsLayout) = defaultVisit(view)
    open fun visit(view: DivSliderView) = defaultVisit(view)
    open fun visit(view: DivSelectView) = defaultVisit(view)
    open fun visit(view: DivVideoView) = defaultVisit(view)
    open fun visit(view: DivCustomWrapper) = defaultVisit(view)
    open fun visit(view: View) = Unit
}

internal fun DivViewVisitor.visitViewTree(view: View) {
    when (view) {
        is DivWrapLayout -> {
            visit(view)
            view.visitChild(this::visitViewTree)
        }
        is DivFrameLayout -> {
            visit(view)
            view.visitChild(this::visitViewTree)
        }
        is DivGridLayout -> {
            visit(view)
            view.visitChild(this::visitViewTree)
        }
        is DivLinearLayout -> {
            visit(view)
            view.visitChild(this::visitViewTree)
        }
        is DivPagerView -> {
            visit(view)
            view.visitChild(this::visitViewTree)
        }
        is DivRecyclerView -> {
            visit(view)
            view.visitChild(this::visitViewTree)
        }
        is DivStateLayout -> {
            visit(view)
            view.visitChild(this::visitViewTree)
        }
        is DivTabsLayout -> {
            visit(view)
            view.visitChild(this::visitViewTree)
        }
        is DivCustomWrapper -> {
            visit(view)
            view.visitChild(this::visitViewTree)
        }
        is DivSeparatorView -> visit(view)
        is DivGifImageView -> visit(view)
        is DivImageView -> visit(view)
        is DivLineHeightTextView -> visit(view)
        is DivPagerIndicatorView -> visit(view)
        is DivSliderView -> visit(view)
        is DivSelectView -> visit(view)
        is DivVideoView -> visit(view)
        else -> {
            visit(view)
            if (view is ViewGroup) {
                view.visitChild(this::visitViewTree)
            }
        }
    }
}

private inline fun ViewGroup.visitChild(func: (childView: View) -> Unit) = children.forEach { func(it) }
