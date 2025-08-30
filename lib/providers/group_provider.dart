import 'dart:async';

import 'package:flutter/material.dart';
import 'package:student_system/services/supabase_database_service.dart';
import 'package:student_system/views/screens/group_screen.dart';

import '../models/group.dart';

class GroupProvider with ChangeNotifier {
  final SupabaseDatabaseService databaseService;
  List<Group> _groups = [];
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<Map<String, dynamic>>>? _groupsSubscription;

  GroupProvider({required this.databaseService}) {
    _listenToGroups();
  }

  List<Group> get groups => _groups;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _listenToGroups() {
    try {
      _groupsSubscription?.cancel();
      _groupsSubscription = databaseService.getGroupsStream().listen(
        (data) {
          _groups = data
              .map((item) => Group.fromSupabase(item))
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

  Future<void> loadGroupsFromServer() async {
    // Groups are now loaded automatically via stream
    // This method is kept for compatibility
    notifyListeners();
  }

  Future<void> addGroup(Group group) async {
    try {
      _isLoading = true;
      notifyListeners();

      await databaseService.addGroup(group.toSupabase());
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteGroup(String groupId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await databaseService.deleteGroup(groupId);
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteGroupByIndex(int index) async {
    if (index >= 0 && index < _groups.length) {
      final groupId = _groups[index].id;
      if (groupId != null) {
        await deleteGroup(groupId);
      }
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

  Future<void> updateGroup(Group updatedGroup) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (updatedGroup.id == null) {
        throw 'Group ID is required for update';
      }

      await databaseService.updateGroup(
        updatedGroup.id!,
        updatedGroup.toSupabase(),
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

  Group? getGroupById(String id) {
    try {
      return _groups.firstWhere((group) => group.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _groupsSubscription?.cancel();
    super.dispose();
  }
}