import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:student_system/utils/object_checker.dart';
import 'package:student_system/utils/shared_pref_utils.dart';

class CommonUtils {
  static String currentLanguage = 'en';

  static getCurrentLang() async {
    String defaultValue = Platform.localeName.split('_')[0];
    defaultValue = await SharedPrefUtil.getString(
        SharedPrefUtil.CurrentLanguage,
        defaultValue: defaultValue);
    if (defaultValue.startsWith("ar")) {
      defaultValue = "ar";
    } else {
      defaultValue = "en";
    }
    return defaultValue;
  }

  static changeLanguage(BuildContext context, {String? language}) async {
    currentLanguage =
        ObjectChecker.firstNotEmptyString([language, await getCurrentLang()]);
    await SharedPrefUtil.setString(
        SharedPrefUtil.CurrentLanguage, currentLanguage);
    await changeLocale(context,
        ObjectChecker.firstNotEmptyString([language, currentLanguage]));
  }
}
