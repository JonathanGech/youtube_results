extension GetOrNullMap on Map {
  /// Retrieves a nested map inside a map, or returns null if the key is absent.
  Map<String, dynamic>? getMap(String key) =>
      this[key] as Map<String, dynamic>?;

  /// Retrieves a value of type [T] inside a map.
  /// Returns null if the key is absent.
  /// Throws an exception if the value is of an unexpected type.
  T? getT<T>(String key) {
    final value = this[key];
    if (value == null) return null;
    if (value is! T) {
      throw Exception('Invalid type: ${value.runtimeType} should be $T');
    }
    return value;
  }

  /// Retrieves a list of maps from a map, or returns null if the key is absent.
  /// Throws an exception if the value is not a List.
  List<Map<String, dynamic>>? getList(String key) {
    final value = this[key];
    if (value == null) return null;
    if (value is! List) {
      throw Exception(
          'Invalid type: ${value.runtimeType} should be List<Map<String, dynamic>>');
    }
    return value.whereType<Map<String, dynamic>>().toList();
  }
}

extension ListUtil<E> on Iterable<E> {
  /// Retrieves an element at [index] safely.
  /// Returns null if the index is out of bounds.
  E? elementAtSafe(int index) =>
      (index >= 0 && index < length) ? elementAt(index) : null;
}
