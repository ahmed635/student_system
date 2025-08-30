import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:student_system/models/student.dart';
import 'package:student_system/providers/student_provider.dart';
import 'package:student_system/views/screens/student_screen.dart';
import 'package:student_system/views/widgets/custom_floating_action_button.dart';
import 'package:student_system/views/widgets/edit_and_delete_buttons.dart';

class StudentListView extends StatefulWidget {
  static String routeName = "/student_list_view";

  @override
  _StudentListViewState createState() => _StudentListViewState();
}

class _StudentListViewState extends State<StudentListView> {
  List<Student> students = []; // Populate with your data

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadStudents();
    });
  }

  _loadStudents() async {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    await provider.loadStudentsFromServer();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(translate('students'))),
      body: provider.students.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.students.length,
              itemBuilder: (context, index) {
                final student = provider.students[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(student.name ?? 'Unknown Student'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Group: ${student.groupName ?? 'No Group'}'),
                        if (student.phone != null) Text('Phone: ${student.phone}'),
                        if (student.email != null) Text('Email: ${student.email}'),
                      ],
                    ),
                    trailing: EditAndDeleteButtons(
                      onEditTapped: () =>
                          provider.editStudent(context, student),
                      onDeleteTapped: () => provider.deleteStudentByIndex(index),
                    ),
                    onTap: () => _showStudentDetails(student),
                  ),
                );
              },
            ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, StudentScreen.routeName),
      ),
    );
  }

  void _showStudentDetails(Student student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(student.name ?? 'Unknown Student'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${student.id ?? 'N/A'}'),
              Text('Group: ${student.groupName ?? 'No Group'}'),
              if (student.phone != null) Text('Phone: ${student.phone}'),
              if (student.email != null) Text('Email: ${student.email}'),
              if (student.createdAt != null) 
                Text('Created: ${student.createdAt!.toLocal().toString().split(' ')[0]}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
