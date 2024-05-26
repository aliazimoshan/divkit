@testable import DivKit
@testable import LayoutKit

import XCTest

import BaseUIPublic
import CommonCorePublic

final class DivBaseExtensionsTests: XCTestCase {
  private let timer = TestTimerScheduler()

  func test_WithId() throws {
    let block = makeBlock(
      divSeparator(
        id: "id1"
      )
    )

    let expectedBlock = StateBlock(
      child: DecoratingBlock(
        child: separatorBlock(),
        accessibilityElement: accessibility(identifier: "id1")
      ),
      ids: []
    )

    assertEqual(block, expectedBlock)
  }

  func test_WithMarginsAndPaddings() throws {
    let block = makeBlock(
      divText(
        margins: DivEdgeInsets(bottom: .value(10), top: .value(10)),
        paddings: DivEdgeInsets(left: .value(20), right: .value(20)),
        text: "Hello!"
      )
    )

    let expectedBlock = StateBlock(
      child: DecoratingBlock(
        child: DecoratingBlock(
          child: textBlock(text: "Hello!"),
          paddings: EdgeInsets(horizontal: 20),
          accessibilityElement: accessibility(
            traits: .staticText,
            label: "Hello!"
          )
        ),
        boundary: .noClip,
        paddings: EdgeInsets(vertical: 10)
      ),
      ids: []
    )

    assertEqual(block, expectedBlock)
  }

  func test_WithAccessibility() throws {
    let block = makeBlock(
      divSeparator(
        accessibility: DivAccessibility(
          description: .value("Accessibility description"),
          type: .button
        ),
        id: "id1"
      )
    )

    let expectedBlock = StateBlock(
      child: DecoratingBlock(
        child: separatorBlock(),
        accessibilityElement: accessibility(
          traits: .button,
          label: "Accessibility description",
          identifier: "id1"
        )
      ),
      ids: []
    )

    assertEqual(block, expectedBlock)
  }

  func test_MarginsOverAccessibility() throws {
    let block = makeBlock(
      divSeparator(
        accessibility: DivAccessibility(
          description: .value("Accessibility description"),
          type: .button
        ),
        margins: DivEdgeInsets(bottom: .value(10), top: .value(10))
      )
    )

    let expectedBlock = StateBlock(
      child: DecoratingBlock(
        child: DecoratingBlock(
          child: separatorBlock(),
          accessibilityElement: accessibility(
            traits: .button,
            label: "Accessibility description"
          )
        ),
        boundary: .noClip,
        paddings: EdgeInsets(vertical: 10)
      ),
      ids: []
    )

    assertEqual(block, expectedBlock)
  }

  func test_WithActions() throws {
    let actions = [
      divAction(
        logId: "action1_log_id",
        url: "https://some.url"
      ),
      divAction(
        logId: "action2_log_id",
        typed: .divActionSetVariable(DivActionSetVariable(
          value: .integerValue(IntegerValue(value: .value(10))),
          variableName: .value("var1")
        ))
      ),
    ]

    let block = makeBlock(
      divContainer(actions: actions)
    )

    let expectedBlock = try StateBlock(
      child: DecoratingBlock(
        child: ContainerBlock(
          layoutDirection: .vertical,
          children: []
        ),
        actions: NonEmptyArray(actions.compactMap(\.uiAction)),
        actionAnimation: .default,
        accessibilityElement: .default
      ),
      ids: []
    )

    assertEqual(block, expectedBlock)
  }

  func test_MarginsOverActions() throws {
    let action = divAction(
      logId: "action_log_id",
      url: "https://some.url"
    )
    let block = makeBlock(
      divSeparator(
        actions: [action],
        margins: DivEdgeInsets(bottom: .value(10), top: .value(10))
      )
    )

    let expectedBlock = StateBlock(
      child: DecoratingBlock(
        child: DecoratingBlock(
          child: separatorBlock(),
          actions: NonEmptyArray(action.uiAction!),
          actionAnimation: .default,
          accessibilityElement: .default
        ),
        boundary: .noClip,
        paddings: EdgeInsets(vertical: 10)
      ),
      ids: []
    )

    assertEqual(block, expectedBlock)
  }

  func test_WithVisibility_Gone() throws {
    let block = makeBlock(
      divSeparator(
        visibility: .value(.gone)
      )
    )

    let expectedBlock = StateBlock(
      child: EmptyBlock.zeroSized,
      ids: []
    )

    assertEqual(block, expectedBlock)
  }

  func test_WithVisibility_Invisible() throws {
    let block = makeBlock(
      divSeparator(
        visibility: .value(.invisible)
      )
    )

    let expectedBlock = StateBlock(
      child: DecoratingBlock(
        child: separatorBlock(),
        childAlpha: 0.0
      ),
      ids: []
    )

    assertEqual(block, expectedBlock)
  }

  func test_WhenCreatesBlockAfterItBeingGone_ReportsVisibility() throws {
    try expectVisibilityActionsToRun(
      forVisibleBlockFile: "div-text-visibility-actions-visible",
      invisibleBlockFile: "div-text-visibility-actions-gone"
    )
  }

  func test_WhenCreatesBlockAfterItBeingInvisible_ReportsVisibility() throws {
    try expectVisibilityActionsToRun(
      forVisibleBlockFile: "div-text-visibility-actions-visible",
      invisibleBlockFile: "div-text-visibility-actions-invisible"
    )
  }

  func test_WhenReusesBlockWithAnotherDivCardID_ExpectToCancelPreviousBlockTimers() throws {
    let context = DivBlockModelingContext(scheduler: timer)

    let firstBlock = try makeBlock(
      fromFile: "div-text-visibility-actions-visible",
      context: context
    )

    // trigger visibility actions for first time
    let rect = CGRect(origin: .zero, size: CGSize(squareDimension: 20))
    let view = firstBlock.makeBlockView()
    view.frame = rect
    view.layoutIfNeeded()
    view.onVisibleBoundsChanged(from: rect, to: rect)

    let oldTimers = timer.timers

    let secondBlock = try makeBlock(
      fromFile: "div-text-visibility-actions-visible",
      context: DivBlockModelingContext(
        cardId: "another_cardId",
        stateManager: DivStateManager(),
        imageHolderFactory: FakeImageHolderFactory()
      )
    )
    let view2 = secondBlock.reuse(
      view,
      observer: nil,
      overscrollDelegate: nil,
      renderingDelegate: nil,
      superview: nil
    )
    view2.frame = rect
    view2.layoutIfNeeded()
    view.onVisibleBoundsChanged(from: rect, to: rect)

    XCTAssertEqual(oldTimers.allSatisfy { !$0.isValid }, true)
  }

  func test_WhenBlockHasVisibilityAndDisappearAction_DoNotShareVisibilityCounter() throws {
    let context = DivBlockModelingContext(scheduler: timer)

    let blockVisibleFirst = try makeBlock(
      fromFile: "div-text-visibility-and-disappear-action",
      context: context
    )

    let rect = CGRect(origin: .zero, size: CGSize(squareDimension: 20))
    let view = blockVisibleFirst.makeBlockView()
    XCTAssertEqual(getViewVisibilityCallCount(view: view, rect: rect, timerScheduler: timer), 1)

    let invisibleRect: CGRect = .zero
    XCTAssertEqual(
      getViewVisibilityCallCount(
        view: view,
        rect: rect,
        visibilityRect: invisibleRect,
        timerScheduler: timer
      ),
      1
    )
  }

  private func expectVisibilityActionsToRun(
    forVisibleBlockFile file: String,
    invisibleBlockFile: String
  ) throws {
    let context = DivBlockModelingContext(scheduler: timer)

    let blockVisibleFirst = try makeBlock(fromFile: file, context: context)

    // trigger visibility actions for first time
    let rect = CGRect(origin: .zero, size: CGSize(squareDimension: 20))
    let view = blockVisibleFirst.makeBlockView()
    XCTAssertEqual(getViewVisibilityCallCount(view: view, rect: rect, timerScheduler: timer), 1)

    // expect to drop lastVisibleBounds
    let _ = try makeBlock(fromFile: invisibleBlockFile, context: context)
    let view2 = blockVisibleFirst.makeBlockView()

    XCTAssertEqual(getViewVisibilityCallCount(view: view2, rect: rect, timerScheduler: timer), 1)
  }
}

private func makeBlock(
  fromFile filename: String,
  context: DivBlockModelingContext = .default
) throws -> Block {
  try DivTextTemplate.make(
    fromFile: filename,
    subdirectory: "div-base",
    context: context
  )
}
