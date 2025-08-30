import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:student_system/providers/auth_provider.dart';
import 'package:student_system/providers/group_provider.dart';
import 'package:student_system/providers/lesson_provider.dart';
import 'package:student_system/providers/student_provider.dart';
import 'package:student_system/services/supabase_auth_service.dart';
import 'package:student_system/services/supabase_database_service.dart';
import 'package:student_system/utils/common_utils.dart';
import 'package:student_system/views/screens/splash_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/app_routes.dart';
import 'config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://nfeyqgypyywzzbhetzgd.supabase.co', // Replace with your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5mZXlxZ3lweXl3enpiaGV0emdkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY1NjMxODEsImV4cCI6MjA3MjEzOTE4MX0.UNdGnVokDRlj-j5ju3Eo--R7nhwrvpcQ40LsudbEixU', // Replace with your Supabase anon key
  );
  
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
          Provider<SupabaseAuthService>(
            create: (_) => SupabaseAuthService(),
          ),
          Provider<SupabaseDatabaseService>(
            create: (_) => SupabaseDatabaseService(),
          ),
          ChangeNotifierProxyProvider<SupabaseAuthService, AuthProvider>(
            create: (context) => AuthProvider(
              authService: context.read<SupabaseAuthService>(),
            ),
            update: (context, authService, previous) =>
                previous ?? AuthProvider(authService: authService),
          ),
          ChangeNotifierProxyProvider<SupabaseDatabaseService, GroupProvider>(
            create: (context) => GroupProvider(
              databaseService: context.read<SupabaseDatabaseService>(),
            ),
            update: (context, databaseService, previous) =>
                previous ?? GroupProvider(databaseService: databaseService),
          ),
          ChangeNotifierProxyProvider<SupabaseDatabaseService, StudentProvider>(
            create: (context) => StudentProvider(
              databaseService: context.read<SupabaseDatabaseService>(),
            ),
            update: (context, databaseService, previous) =>
                previous ?? StudentProvider(databaseService: databaseService),
          ),
          ChangeNotifierProxyProvider<SupabaseDatabaseService, LessonProvider>(
            create: (context) => LessonProvider(
              databaseService: context.read<SupabaseDatabaseService>(),
            ),
            update: (context, databaseService, previous) =>
                previous ?? LessonProvider(databaseService: databaseService),
          ),
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
