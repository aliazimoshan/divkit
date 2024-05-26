import 'package:divkit/src/core/protocol/div_variable.dart';
import 'package:divkit/src/core/variable/variable.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

class DefaultDivVariableStorage extends DivVariableStorage with EquatableMixin {
  final _storage = BehaviorSubject<Map<String, DivVariable>>();

  /// Inherited storage of reactive variables. Not managed by local storage.
  @override
  final DivVariableStorage? inheritedStorage;

  @override
  Set<String> get names => _storage.isClosed ? {} : _storage.value.keys.toSet();

  DefaultDivVariableStorage({
    this.inheritedStorage,
    List<DivVariable>? variables,
  }) {
    _storage.add(Map.fromIterable(variables ?? [], key: (v) => v.name));
  }

  @override
  bool update(DivVariable variable) {
    final isLocal = names.contains(variable.name);
    final isInherited =
        inheritedStorage?.names.contains(variable.name) ?? false;

    if (isLocal) {
      _storage
          .add(Map.of(_storage.value)..update(variable.name, (_) => variable));
    } else if (isInherited) {
      inheritedStorage?.update(variable);
    }

    return isLocal || isInherited;
  }

  @override
  void put(DivVariable variable) {
    if (!update(variable)) {
      _storage.add(Map.of(_storage.value)..addAll({variable.name: variable}));
    }
  }

  @override
  Map<String, DivVariable> get value => _storage.isClosed
      ? {}
      : {
          ...?inheritedStorage?.value,
          ..._storage.value,
        };

  /// Caching the combined contextStream.
  Stream<Map<String, DivVariable>>? _contextStream;

  @override
  Stream<Map<String, DivVariable>> get stream {
    if (_contextStream == null) {
      final inheritedStream = inheritedStorage?.stream;
      if (inheritedStream != null) {
        _contextStream = CombineLatestStream.combine2(
          inheritedStream,
          _storage.stream,
          (Map inherited, Map local) => {
            ...inherited,
            ...local,
          },
        );
      } else {
        _contextStream = _storage.stream;
      }
    }

    return _contextStream!;
  }

  @override
  Future<void> dispose() => _storage.close();

  @override
  List<Object?> get props => [_storage, inheritedStorage];
}
