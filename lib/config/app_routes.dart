import 'package:student_system/views/auth/login_screen.dart';
import 'package:student_system/views/auth/register_screen.dart';
import 'package:student_system/views/listviews/group_list_view.dart';
import 'package:student_system/views/listviews/lesson_list_view.dart';
import 'package:student_system/views/listviews/student_list_view.dart';
import 'package:student_system/views/screens/group_screen.dart';
import 'package:student_system/views/screens/home_screen.dart';
import 'package:student_system/views/screens/lesson_screen.dart';
import 'package:student_system/views/screens/splash_screen.dart';
import 'package:student_system/views/screens/student_screen.dart';

var appRoutes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
  LoginScreen.routeName: (context) => LoginScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  StudentListView.routeName: (context) => StudentListView(),
  GroupListView.routeName: (context) => GroupListView(),
  LessonListView.routeName: (context) => LessonListView(),
  GroupScreen.routeName: (context) => GroupScreen(),
  StudentScreen.routeName: (context) => StudentScreen(),
  LessonScreen.routeName: (context) => LessonScreen(),
};
