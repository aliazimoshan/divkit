// Generated code. Do not modify.

import 'package:divkit/src/utils/parsing_utils.dart';
import 'package:equatable/equatable.dart';

/// Manages video playback.
class DivActionVideo extends Resolvable with EquatableMixin {
  const DivActionVideo({
    required this.action,
    required this.id,
  });

  static const type = "video";

  /// Defines the action for the video:
  /// • `start` — starts playing the video if the video is ready to be played, or schedules playback
  /// • `pause' — stops the video playback
  final Expression<DivActionVideoAction> action;

  /// Video ID.
  final Expression<String> id;

  @override
  List<Object?> get props => [
        action,
        id,
      ];

  DivActionVideo copyWith({
    Expression<DivActionVideoAction>? action,
    Expression<String>? id,
  }) =>
      DivActionVideo(
        action: action ?? this.action,
        id: id ?? this.id,
      );

  static DivActionVideo? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      return DivActionVideo(
        action: safeParseStrEnumExpr(
          json['action'],
          parse: DivActionVideoAction.fromJson,
        )!,
        id: safeParseStrExpr(
          json['id']?.toString(),
        )!,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  DivActionVideo resolve(DivVariableContext context) {
    action.resolve(context);
    id.resolve(context);
    return this;
  }
}

enum DivActionVideoAction implements Resolvable {
  start('start'),
  pause('pause');

  final String value;

  const DivActionVideoAction(this.value);
  bool get isStart => this == start;

  bool get isPause => this == pause;

  T map<T>({
    required T Function() start,
    required T Function() pause,
  }) {
    switch (this) {
      case DivActionVideoAction.start:
        return start();
      case DivActionVideoAction.pause:
        return pause();
    }
  }

  T maybeMap<T>({
    T Function()? start,
    T Function()? pause,
    required T Function() orElse,
  }) {
    switch (this) {
      case DivActionVideoAction.start:
        return start?.call() ?? orElse();
      case DivActionVideoAction.pause:
        return pause?.call() ?? orElse();
    }
  }

  static DivActionVideoAction? fromJson(
    String? json,
  ) {
    if (json == null) {
      return null;
    }
    try {
      switch (json) {
        case 'start':
          return DivActionVideoAction.start;
        case 'pause':
          return DivActionVideoAction.pause;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  DivActionVideoAction resolve(DivVariableContext context) => this;
}
