import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:student_system/providers/lesson_provider.dart';
import 'package:student_system/views/screens/lesson_screen.dart';
import 'package:student_system/views/widgets/custom_floating_action_button.dart';
import 'package:student_system/views/widgets/edit_and_delete_buttons.dart';

class LessonListView extends StatefulWidget {
  static String routeName = "/lesson_list_view";

  @override
  State<LessonListView> createState() => _LessonListViewState();
}

class _LessonListViewState extends State<LessonListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadLessons();
      setState(() {});
    });
  }

  _loadLessons() async {
    final provider = Provider.of<LessonProvider>(context, listen: false);
    await provider.loadLessonsFromServer();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LessonProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text(translate('lessons'))),
      body: provider.lessons.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.lessons.length,
              itemBuilder: (context, index) {
                final lesson = provider.lessons[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text("${lesson.group?.id}"),
                    subtitle: Text('Group: ${lesson.group}'),
                    trailing: EditAndDeleteButtons(
                      onEditTapped: () => provider.editLesson(context, lesson),
                      onDeleteTapped: () => provider.deleteLesson(index),
                    ),
                    // onTap: () => _showStudentDetails(lesson),
                  ),
                );
              },
            ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, LessonScreen.routeName),
      ),
    );
  }
}
