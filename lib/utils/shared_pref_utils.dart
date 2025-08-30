import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefUtil {
  static var _pref;

  static final String CurrentLanguage = "currentLanguage";

  static Future<SharedPreferences> prefInstance() async {
    _pref ??= await SharedPreferences.getInstance();
    return _pref;
  }

  static Future<String> getString(String key, {String? defaultValue}) async {
    SharedPreferences pref = await prefInstance();
    String? value = pref.getString(key);
    if (value == null && defaultValue != null) {
      pref.setString(key, defaultValue);
    }
    return (value ?? defaultValue) ?? '';
  }

  static Future<bool> setString(String key, String value) async {
    return (await prefInstance()).setString(key, value);
  }

  static Future<bool> remove(String key) async {
    return (await prefInstance()).remove(key);
  }

  static Future<List<String>> getStringList(String key) async {
    return (await prefInstance()).getStringList(key) ?? [];
  }

  static Future<bool> setStringList(String key, List<String> values) async {
    return (await prefInstance()).setStringList(key, values);
  }

  static Future<bool> getBool(String key, {bool? defaultValue}) async {
    SharedPreferences pref = await prefInstance();
    bool? value = pref.getBool(key);
    if (value == null && defaultValue != null) pref.setBool(key, defaultValue);
    return (value ?? defaultValue) ?? false;
  }

  static Future<bool> setBool(String key, bool value) async {
    return (await prefInstance()).setBool(key, value);
  }

  static Future<int> getInt(String key, {int? defaultValue}) async {
    SharedPreferences pref = await prefInstance();
    int? value = pref.getInt(key);
    if (value == null && defaultValue != null) pref.setInt(key, defaultValue);
    return (value ?? defaultValue) ?? 0;
  }

  static Future<bool> setInt(String key, int value) async {
    return (await prefInstance()).setInt(key, value);
  }

  static Future<double> getDouble(String key, {double? defaultValue}) async {
    SharedPreferences pref = await prefInstance();
    double? value = pref.getDouble(key);
    if (value == null && defaultValue != null) {
      pref.setDouble(key, defaultValue);
    }
    return (value ?? defaultValue) ?? 0.0;
  }

  static Future<bool> setDouble(String key, double value) async {
    return (await prefInstance()).setDouble(key, value);
  }

  static Future<Map<String, dynamic>> readMapForKeys(List<String> keys) async {
    SharedPreferences pref = await prefInstance();
    Map<String, dynamic> map = {};
    for (var key in keys) {
      map.putIfAbsent(key, () => pref.get(key));
    }
    return map;
  }

  static Future<bool> containsKey(String key) async {
    return (await prefInstance()).containsKey(key);
  }

  static clearPrefs(List<String> list) async {
    try {
      for (var key in list) {
        (await prefInstance()).remove(key);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
    return true;
  }

  static Future<bool> setObjectPrintFormula(
      String mobileEntityType, Map<String, dynamic> entityInfo) async {
    return (await prefInstance()).setString(
        '${mobileEntityType}_PrintObjectFormula',
        entityInfo["objectFormula"] ?? '');
  }

  static Future<bool> setCustomFields(
      String mobileEntityType, Map<String, dynamic> fields) async {
    fields.forEach((key, value) async {
      value.removeWhere((element) => element == null);
      (await prefInstance())
          .setStringList("${mobileEntityType}_$key", value.cast<String>());
    });
    return true;
  }
}
