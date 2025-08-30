import 'package:flutter/material.dart';
import 'package:student_system/views/screens/group_screen.dart';

import '../models/group.dart';

class GroupProvider with ChangeNotifier {
  List<Group> _groups = [];
  bool _isLoading = false;
  String? _error;

  List<Group> get groups => _groups;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Future<void> loadGroupsFromServer() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate network request
      await Future.delayed(const Duration(seconds: 1));

      _groups = List.generate(
          5, (i) => Group(id: "id$i", name: "name$i"));

      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addGroup(Group group) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Save to database
      await Future.delayed(const Duration(milliseconds: 500));

      _groups.add(group);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteGroup(int index) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Remove from database
      await Future.delayed(const Duration(milliseconds: 500));

      _groups.removeAt(index);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void editGroup(BuildContext context, Group group) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupScreen(group: group),
      ),
    );
  }

  // In GroupProvider class
  Future<void> updateGroup(Group updatedGroup) async {
    try {
      _isLoading = true;
      notifyListeners();

      // TODO: Update in database
      await Future.delayed(const Duration(milliseconds: 500));

      final index = _groups.indexWhere((g) => g.id == updatedGroup.id);
      if (index != -1) {
        _groups[index] = updatedGroup;
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
