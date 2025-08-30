import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:student_system/config/app_colors.dart';
import 'package:student_system/models/group.dart';
import 'package:student_system/models/lesson.dart';
import 'package:student_system/providers/group_provider.dart';
import 'package:student_system/providers/lesson_provider.dart';
import 'package:student_system/utils/object_checker.dart';
import 'package:student_system/views/widgets/custom_drop_down_menu.dart';

class LessonScreen extends StatefulWidget {
  static String routeName = "/lesson_screen";
  Lesson? lesson;

  LessonScreen({super.key, this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final _formKey = GlobalKey<FormState>();
  late Lesson _editLesson;
  List<Group> groups = [];

  @override
  void initState() {
    super.initState();
    _editLesson = widget.lesson ?? Lesson();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadGroups();
      setState(() {});
    });
  }

  _loadGroups() async {
    final provider = Provider.of<GroupProvider>(context, listen: false);
    await provider.loadGroupsFromServer();
    groups = provider.groups;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LessonProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.lesson == null
              ? translate("add_lesson")
              : translate("edit_lesson"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 20,
            children: [
              CustomDropdownMenu<Group>(
                hintText: "Group",
                items: groups,
                selectedItem: _editLesson.group,
                compareFn: (p0, p1) => ObjectChecker.areEqual(p0.id, p1.id),
                onChanged: (value) {
                  setState(() {
                    _editLesson.group = value;
                    // Load students for this group
                  });
                },
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: DataTable(
                      columnSpacing: 15,
                      horizontalMargin: 30,
                      showBottomBorder: true,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            width: 1,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      headingRowColor:
                          WidgetStateProperty.all(AppColors.primary),
                      columns: [
                        _buildHeaderLabel('Student'),
                        _buildHeaderLabel('Attended'),
                        _buildHeaderLabel('Paid'),
                      ],
                      rows: provider.lines.map((line) {
                        return DataRow(
                          color: WidgetStateProperty.all(AppColors.card),
                          cells: [
                            DataCell(Center(child: Text(line.student!.name!))),
                            DataCell(
                              Center(
                                child: Checkbox(
                                  value: line.attended,
                                  onChanged: (value) {
                                    setState(() {
                                      line.attended = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            DataCell(
                              Center(
                                child: Checkbox(
                                  value: line.paid,
                                  onChanged: (value) {
                                    setState(() {
                                      line.paid = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            // Add more cells for additional columns
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _saveLesson(provider),
                child: Text(
                  widget.lesson == null
                      ? translate("add_lesson")
                      : translate("edit_lesson"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildHeaderLabel(String? label) {
    return DataColumn(
      label: Text(
        label!,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.white,
          fontSize: 20,
        ),
      ),
      headingRowAlignment: MainAxisAlignment.center,
    );
  }

  Future<void> _saveLesson(LessonProvider groupProvider) async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.lesson == null) {
          // Add new group
          await groupProvider.addLesson(_editLesson);
        } else {
          // Update existing group
          await groupProvider.updateLesson(_editLesson);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving group: ${e.toString()}')),
        );
      }
    }
  }
}
