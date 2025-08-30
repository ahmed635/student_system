import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:student_system/config/app_drawer.dart';
import 'package:student_system/views/screens/group_screen.dart';
import 'package:student_system/views/screens/lesson_screen.dart';
import 'package:student_system/views/screens/student_screen.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home_screen";

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(translate("main_page"))),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildActionButton(
              icon: Icons.person_add,
              label: translate("add_student"),
              routeName: StudentScreen.routeName,
            ),
            _buildActionButton(
              icon: Icons.group,
              label: translate("add_group"),
              routeName: GroupScreen.routeName,
            ),
            _buildActionButton(
              icon: Icons.schedule,
              label: translate("add_lesson"),
              routeName: LessonScreen.routeName,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      {IconData? icon, String? label, String? routeName}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, routeName!),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              SizedBox(height: 8),
              Text(label!, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
