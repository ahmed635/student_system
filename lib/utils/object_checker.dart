class ObjectChecker {
  static bool isEmptyOrNull(Object? object) {
    if (object == null) return true;
    if (object is String) return object.isEmpty;
    if (object is List) return object.isEmpty;
    if (object is Map) return object.isEmpty;
    return false;
  }

  static bool isNotEmptyOrNull(Object? object) {
    return !isEmptyOrNull(object);
  }

  static bool areAllEmptyOrNull(List<Object?> objects) {
    for (var value in objects) {
      if (isNotEmptyOrNull(value)) return false;
    }
    return true;
  }

  static bool isAnyEmptyOrNull(List<Object?> objects) {
    for (Object? value in objects) {
      if (isEmptyOrNull(value)) return true;
    }
    return false;
  }

  static bool isAnyNotEmptyOrNull(List<Object?> objects) {
    for (Object? value in objects) {
      if (isNotEmptyOrNull(value)) return true;
    }
    return false;
  }

  static bool areEqual(String? s1, String? s2) {
    if (isAnyEmptyOrNull([s1, s2])) return false;
    return s1?.trim() == s2?.trim();
  }

  static bool areNotEqual(String? s1, String? s2) {
    return !areEqual(s1, s2);
  }

  static bool isAnyEqualToFirst(String? first, List<String?> objects) {
    for (var value in objects) {
      if (areEqual(value, first)) return true;
    }
    return false;
  }

  static bool areAllNotEqualToFirst(String? first, List<String?> objects) {
    for (var value in objects) {
      if (areEqual(value, first)) return false;
    }
    return true;
  }

  static bool toFalseIfNull(bool? b) {
    return b ?? false;
  }

  static bool toTrueIfNull(bool? b) {
    return b ?? true;
  }

  static String toEmptyIfNull(String? str) {
    return str ?? "";
  }

  static firstNotEmptyString(List<String?> list) {
    for (String? s in list) {
      if (s != null && s.isNotEmpty) return s;
    }
    return '';
  }

  static bool isEmptyOrZero(double? number) {
    return (number ?? 0.0) == 0.0;
  }

  static bool areAllNotEmptyOrNull(List<Object?> objects) {
    for (Object? value in objects) {
      if (isEmptyOrNull(value)) return false;
    }
    return true;
  }

  static findNotFirstEmptyOrZero(List<double?> list) {
    for (double? value in list) {
      if (isNotEmptyOrZero(value)) return value;
    }
    return 0.0;
  }

  static bool isNotEmptyOrZero(double? value) =>
      !ObjectChecker.isEmptyOrZero(value);

  static bool isFalse(bool? object) {
    return !isTrue(object);
  }

  static bool isAnyTrue(List<bool?> objects) {
    for (var value in objects) {
      if (isTrue(value)) return true;
    }
    return false;
  }

  static bool isTrue(bool? object) {
    if (object == null) return false;
    return object;
  }
}
