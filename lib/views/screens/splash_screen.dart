import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_system/config/app_colors.dart';
import 'package:student_system/providers/auth_provider.dart';
import 'package:student_system/utils/common_utils.dart';
import 'package:student_system/views/auth/login_screen.dart';
import 'package:student_system/views/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash_screen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => initializeScreen());
  }

  initializeScreen() async {
    await CommonUtils.changeLanguage(context);
    await _checkAuthAndNavigate();
    setState(() {});
  }

  _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      final authProvider = context.read<AuthProvider>();
      final user = authProvider.user;
      
      if (user != null) {
        // User is logged in, navigate to home
        Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      } else {
        // User is not logged in, navigate to login
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/logo.jpg'),
            ),
            SizedBox(height: 20),

            // App Title
            Text(
              'Student Attendance',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            SizedBox(height: 40),

            CircularProgressIndicator(
              color: AppColors.white,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}