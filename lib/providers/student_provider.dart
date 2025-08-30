import 'dart:async';

import 'package:flutter/material.dart';
import 'package:student_system/models/student.dart';
import 'package:student_system/services/supabase_database_service.dart';

import '../views/screens/student_screen.dart';

class StudentProvider with ChangeNotifier {
  final SupabaseDatabaseService databaseService;
  List<Student> _students = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<Map<String, dynamic>>>? _studentsSubscription;
  String? _currentGroupId;

  StudentProvider({required this.databaseService}) {
    _listenToStudents();
  }

  List<Student> get students => _students;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _listenToStudents({String? groupId}) {
    try {
      _currentGroupId = groupId;
      _studentsSubscription?.cancel();
      _studentsSubscription = databaseService.getStudentsStream(groupId: groupId).listen(
        (data) {
          _students = data
              .map((item) => Student.fromSupabase(item))
              .toList();
          _error = null;
          notifyListeners();
        },
        onError: (error) {
          _error = error.toString();
          notifyListeners();
        },
      );
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void filterByGroup(String? groupId) {
    _listenToStudents(groupId: groupId);
  }

  Future<void> loadStudentsFromServer() async {
    // Students are now loaded automatically via stream
    // This method is kept for compatibility
    notifyListeners();
  }

  Future<void> addStudent(Student student) async {
    try {
      _isLoading = true;
      notifyListeners();

      await databaseService.addStudent(student.toSupabase());
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteStudent(String studentId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await databaseService.deleteStudent(studentId);
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteStudentByIndex(int index) async {
    if (index >= 0 && index < _students.length) {
      final studentId = _students[index].id;
      if (studentId != null) {
        await deleteStudent(studentId);
      }
    }
  }

  void editStudent(BuildContext context, Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentScreen(student: student),
      ),
    );
  }

  Future<void> updateStudent(Student updatedStudent) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (updatedStudent.id == null) {
        throw 'Student ID is required for update';
      }

      await databaseService.updateStudent(
        updatedStudent.id!,
        updatedStudent.toSupabase(),
      );

      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Student> getStudentsByGroup(String groupId) {
    return _students.where((student) => student.groupId == groupId).toList();
  }

  Student? getStudentById(String id) {
    try {
      return _students.firstWhere((student) => student.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _studentsSubscription?.cancel();
    super.dispose();
  }
}