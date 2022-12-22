import Foundation

public protocol AnimationSourceType {}

@frozen
public enum LottieAnimationSourceType: AnimationSourceType, Equatable {
  case json([String: Any])
  case data(Data)

  public static func ==(lhs: LottieAnimationSourceType, rhs: LottieAnimationSourceType) -> Bool {
    switch (lhs, rhs) {
    case let (.data(lhs), .data(rhs)):
      return lhs == rhs
    case let (.json(lhs), .json(rhs)):
      return NSDictionary(dictionary: lhs).isEqual(to: rhs)
    case (.data, _), (.json, _):
      return false
    }
  }
}

@frozen
public enum RiveAnimationSourceType: AnimationSourceType, Equatable {
  case data(Data)

  public static func ==(lhs: RiveAnimationSourceType, rhs: RiveAnimationSourceType) -> Bool {
    switch (lhs, rhs) {
    case let (.data(lhs), .data(rhs)):
      return lhs == rhs
    }
  }
}
