import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../models/student.dart';
import '../../providers/student_provider.dart';
import '../widgets/custom_text_form_field.dart';

class StudentScreen extends StatefulWidget {
  final Student? student;
  static String routeName = "/student_screen";

  const StudentScreen({super.key, this.student});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late Student _editStudent;

  @override
  void initState() {
    super.initState();
    _editStudent = widget.student ?? Student();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.student == null
              ? translate("add_student")
              : translate("edit_student"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              CustomTextFormField(
                hintText: "student_name",
                value: _editStudent.name,
                onChanged: (value) {
                  _editStudent.name = value!;
                  setState(() {});
                },
                required: true,
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                hintText: "student_name",
                value: _editStudent.name,
                onChanged: (value) {
                  _editStudent.name = value!;
                  setState(() {});
                },
                required: true,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => _saveStudent(provider),
                child: Text(
                  widget.student == null
                      ? translate("add_student")
                      : translate("edit_student"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveStudent(StudentProvider studentProvider) async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.student == null) {
          // Add new student
          await studentProvider.addStudent(_editStudent);
        } else {
          // Update existing Student
          await studentProvider.updateStudent(_editStudent);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving student: ${e.toString()}')),
        );
      }
    }
  }
}
