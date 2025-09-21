/// 安全的集合操作擴展
///
/// 提供安全的集合操作方法，避免 StateError (Bad state: No element) 例外
extension SafeCollectionExtensions<T> on Iterable<T> {
  /// 安全地獲取第一個元素，如果集合為空則返回 null
  T? get firstOrNull {
    try {
      return isEmpty ? null : first;
    } catch (e) {
      return null;
    }
  }

  /// 安全地獲取第一個元素，如果集合為空則返回預設值
  T firstOrDefault(T defaultValue) {
    try {
      return isEmpty ? defaultValue : first;
    } catch (e) {
      return defaultValue;
    }
  }

  /// 安全地獲取最後一個元素，如果集合為空則返回 null
  T? get lastOrNull {
    try {
      return isEmpty ? null : last;
    } catch (e) {
      return null;
    }
  }

  /// 安全地獲取最後一個元素，如果集合為空則返回預設值
  T lastOrDefault(T defaultValue) {
    try {
      return isEmpty ? defaultValue : last;
    } catch (e) {
      return defaultValue;
    }
  }

  /// 安全地獲取指定索引的元素，如果索引超出範圍則返回 null
  T? elementAtOrNull(int index) {
    try {
      if (index < 0 || index >= length) return null;
      return elementAt(index);
    } catch (e) {
      return null;
    }
  }

  /// 安全地獲取指定索引的元素，如果索引超出範圍則返回預設值
  T elementAtOrDefault(int index, T defaultValue) {
    try {
      if (index < 0 || index >= length) return defaultValue;
      return elementAt(index);
    } catch (e) {
      return defaultValue;
    }
  }
}

/// 安全的列表操作擴展
extension SafeListExtensions<T> on List<T> {
  /// 安全地獲取第一個元素，如果列表為空則返回 null
  T? get firstOrNull {
    try {
      return isEmpty ? null : first;
    } catch (e) {
      return null;
    }
  }

  /// 安全地獲取第一個元素，如果列表為空則返回預設值
  T firstOrDefault(T defaultValue) {
    try {
      return isEmpty ? defaultValue : first;
    } catch (e) {
      return defaultValue;
    }
  }

  /// 安全地獲取最後一個元素，如果列表為空則返回 null
  T? get lastOrNull {
    try {
      return isEmpty ? null : last;
    } catch (e) {
      return null;
    }
  }

  /// 安全地獲取最後一個元素，如果列表為空則返回預設值
  T lastOrDefault(T defaultValue) {
    try {
      return isEmpty ? defaultValue : last;
    } catch (e) {
      return defaultValue;
    }
  }

  /// 安全地獲取指定索引的元素，如果索引超出範圍則返回 null
  T? elementAtOrNull(int index) {
    try {
      if (index < 0 || index >= length) return null;
      return this[index];
    } catch (e) {
      return null;
    }
  }

  /// 安全地獲取指定索引的元素，如果索引超出範圍則返回預設值
  T elementAtOrDefault(int index, T defaultValue) {
    try {
      if (index < 0 || index >= length) return defaultValue;
      return this[index];
    } catch (e) {
      return defaultValue;
    }
  }
}
