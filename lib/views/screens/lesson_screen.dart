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
              if (groups.isNotEmpty)
                CustomDropdownMenu<Group>(
                  hintText: "Select Group",
                  items: groups,
                  selectedItem: _editLesson.groupId != null 
                      ? groups.where((g) => g.id == _editLesson.groupId).isNotEmpty
                          ? groups.firstWhere((g) => g.id == _editLesson.groupId)
                          : null
                      : null,
                  compareFn: (p0, p1) => ObjectChecker.areEqual(p0.id, p1.id),
                  onChanged: (value) {
                    setState(() {
                      _editLesson.groupId = value?.id;
                      _editLesson.groupName = value?.name;
                      // Load students for this group
                    });
                  },
                )
              else 
                Container(
                  padding: EdgeInsets.all(16),
                  child: Text('No groups available. Please create a group first.'),
                ),
              
              // Topic Input
              TextFormField(
                initialValue: _editLesson.topic,
                decoration: InputDecoration(
                  labelText: 'Topic',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _editLesson.topic = value.isNotEmpty ? value : null;
                },
              ),
              
              // Date Input
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _editLesson.date ?? DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) {
                    setState(() {
                      _editLesson.date = date;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _editLesson.date != null 
                        ? _editLesson.date!.toLocal().toString().split(' ')[0]
                        : 'Select Date',
                  ),
                ),
              ),
              
              // Notes Input
              TextFormField(
                initialValue: _editLesson.notes,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  _editLesson.notes = value.isNotEmpty ? value : null;
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
                      rows: provider.getLessonLines(_editLesson.id ?? '').map((line) {
                        return DataRow(
                          color: WidgetStateProperty.all(AppColors.card),
                          cells: [
                            DataCell(Center(child: Text(line.studentName ?? 'Unknown'))),
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
