import 'package:flutter/material.dart';
import 'package:student_system/views/auth/register_screen.dart';

import '../../config/app_colors.dart';
import '../screens/home_screen.dart';


class LoginScreen extends StatelessWidget {
  static String routeName = "/login_screen";

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.jpg', height: 150),
              SizedBox(height: 40),
              Text(
                'Student Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Image.asset('assets/images/google.png', height: 24),
                label: Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                },
              ),
              SizedBox(height: 20),
              TextButton(
                child: Text(
                  'Register instead',
                  style: TextStyle(
                    color: AppColors.primary,
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, RegisterScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
