import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:student_system/utils/common_utils.dart';
import 'package:student_system/utils/object_checker.dart';
import 'package:student_system/views/auth/login_screen.dart';
import 'package:student_system/views/listviews/group_list_view.dart';
import 'package:student_system/views/listviews/lesson_list_view.dart';
import 'package:student_system/views/listviews/student_list_view.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(context),
          _buildDrawerItem(
            icon: Icons.person,
            title: translate('students'),
            routeName: StudentListView.routeName,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.group,
            title: translate('groups'),
            routeName: GroupListView.routeName,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.schedule,
            title: translate('lessons'),
            routeName: LessonListView.routeName,
            context: context,
          ),
          Divider(),
          _buildChangeLanguageButton(context),
          _buildDrawerItem(
            icon: Icons.logout,
            title: translate('logout'),
            routeName: LoginScreen.routeName,
            context: context,
          ),
        ],
      ),
    );
  }

  DrawerHeader _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/images/logo.jpg'),
          ),
          SizedBox(height: 10),
          Text('User Name',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          Text('User@example.com', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      {IconData? icon,
      String? title,
      String? routeName,
      BuildContext? context}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title!),
      onTap: () {
        Navigator.pop(context!);
        Navigator.pushNamed(context, routeName!);
      },
    );
  }

  _buildChangeLanguageButton(context) {
    var arabic = ObjectChecker.areEqual(CommonUtils.currentLanguage, "ar");
    var title = arabic ? "الانجلزية" : "Arabic";
    return ListTile(
      leading: Icon(Icons.language),
      title: Text(title),
      onTap: () async {
        if (arabic) {
          await CommonUtils.changeLanguage(context, language: "en");
        } else {
          await CommonUtils.changeLanguage(context, language: "ar");
        }
        setState(() {});
      },
    );
  }
}
