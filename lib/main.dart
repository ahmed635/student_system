import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:student_system/providers/group_provider.dart';
import 'package:student_system/providers/lesson_provider.dart';
import 'package:student_system/providers/student_provider.dart';
import 'package:student_system/utils/common_utils.dart';
import 'package:student_system/views/screens/splash_screen.dart';

import 'config/app_routes.dart';
import 'config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String language = await CommonUtils.getCurrentLang();
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: language,
    supportedLocales: ['en', 'ar'],
  );

  runApp(
    LocalizedApp(
      delegate,
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GroupProvider()),
          ChangeNotifierProvider(create: (_) => StudentProvider()),
          ChangeNotifierProvider(create: (_) => LessonProvider()),
        ],
        child: StudentSystem(),
      ),
    ),
  );
}

class StudentSystem extends StatefulWidget {
  const StudentSystem({super.key});

  @override
  State<StudentSystem> createState() => _StudentSystemState();
}

class _StudentSystemState extends State<StudentSystem> {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: translate("student_system"),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          localizationDelegate,
        ],
        locale: localizationDelegate.currentLocale,
        supportedLocales: localizationDelegate.supportedLocales,
        theme: AppTheme.light,
        home: SplashScreen(),
        routes: appRoutes,
      ),
    );
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
