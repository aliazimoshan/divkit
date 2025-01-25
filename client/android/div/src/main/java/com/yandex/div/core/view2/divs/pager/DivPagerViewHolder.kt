package com.yandex.div.core.view2.divs.pager

import android.view.View
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.yandex.div.R
import com.yandex.div.core.state.DivStatePath
import com.yandex.div.core.util.doOnEveryDetach
import com.yandex.div.core.view2.BindingContext
import com.yandex.div.core.view2.DivBinder
import com.yandex.div.core.view2.DivViewCreator
import com.yandex.div.core.view2.animations.DivComparator
import com.yandex.div.core.view2.divs.getChildPathUnit
import com.yandex.div.core.view2.divs.resolvePath
import com.yandex.div.core.view2.divs.resolveRuntime
import com.yandex.div.core.view2.divs.widgets.DivHolderView
import com.yandex.div.core.view2.divs.widgets.ReleaseUtils.releaseAndRemoveChildren
import com.yandex.div.core.view2.reuse.util.tryRebindRecycleContainerChildren
import com.yandex.div.internal.KLog
import com.yandex.div2.Div

internal class DivPagerViewHolder(
    private val parentContext: BindingContext,
    private val frameLayout: ViewGroup,
    private val divBinder: DivBinder,
    private val viewCreator: DivViewCreator,
    private val path: DivStatePath,
    private val accessibilityEnabled: Boolean,
) : RecyclerView.ViewHolder(frameLayout) {

    init {
        itemView.doOnEveryDetach { view ->
            val div = oldDiv ?: return@doOnEveryDetach
            parentContext.divView.div2Component.visibilityActionTracker
                .startTrackingViewsHierarchy(parentContext, view, div)
        }
    }

    private var oldDiv: Div? = null
    private val childrenPaths = mutableMapOf<String, DivStatePath>()

    fun bind(bindingContext: BindingContext, div: Div, position: Int) {
        val resolver = bindingContext.expressionResolver

        if (frameLayout.tryRebindRecycleContainerChildren(bindingContext.divView, div)) {
            oldDiv = div
            return
        }

        val divView = frameLayout.getChildAt(0)
            ?.takeIf { oldDiv != null }
            ?.takeIf { child ->
                (child as? DivHolderView<*>)?.bindingContext?.expressionResolver?.let {
                    DivComparator.areDivsReplaceable(oldDiv, div, it, resolver)
                } == true
            } ?: createChildView(bindingContext, div)

        if (accessibilityEnabled) {
            frameLayout.setTag(R.id.div_pager_item_clip_id, position)
        }
        oldDiv = div

        val id = div.value().getChildPathUnit(position)
        val childPath = childrenPaths.getOrPut(id) { div.value().resolvePath(id, path) }

        if (parentContext.expressionResolver != bindingContext.expressionResolver) {
            resolveRuntime(
                runtimeStore = bindingContext.runtimeStore,
                div = div.value(),
                childPath.fullPath,
                resolver = resolver,
                parentResolver = parentContext.expressionResolver,
            )
        }

        divBinder.bind(bindingContext, divView, div, childPath)
        bindingContext.runtimeStore?.showWarningIfNeeded(div.value())
    }

    private fun createChildView(bindingContext: BindingContext, div: Div): View {
        oldDiv?.let {
            KLog.d(TAG) { "Pager holder reuse failed" }
        }

        frameLayout.releaseAndRemoveChildren(bindingContext.divView)
        return viewCreator.create(div, bindingContext.expressionResolver).also {
            frameLayout.addView(it)
        }
    }

    companion object {
        const val TAG = "DivPagerViewHolder"
    }
}
