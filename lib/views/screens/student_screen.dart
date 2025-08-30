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
                labelText: "Student Name",
                controller: TextEditingController(text: _editStudent.name),
                onChanged: (value) {
                  _editStudent.name = value;
                },
                required: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: "Phone Number",
                controller: TextEditingController(text: _editStudent.phone),
                onChanged: (value) {
                  _editStudent.phone = value?.isNotEmpty == true ? value : null;
                },
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                labelText: "Email",
                controller: TextEditingController(text: _editStudent.email),
                onChanged: (value) {
                  _editStudent.email = value?.isNotEmpty == true ? value : null;
                },
                validator: (value) {
                  if (value != null && value.isNotEmpty && !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
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
