import 'dart:async';

import 'package:flutter/material.dart';
import 'package:student_system/models/lesson_line.dart';
import 'package:student_system/services/supabase_database_service.dart';
import 'package:student_system/views/screens/lesson_screen.dart';

import '../models/lesson.dart';

class LessonProvider with ChangeNotifier {
  final SupabaseDatabaseService databaseService;
  List<Lesson> _lessons = [];
  final Map<String, List<LessonLine>> _lessonLines = {};
  bool _isLoading = false;
  String? _error;
  StreamSubscription<List<Map<String, dynamic>>>? _lessonsSubscription;
  final Map<String, StreamSubscription<List<Map<String, dynamic>>>> _lessonLinesSubscriptions = {};
  String? _currentGroupId;

  LessonProvider({required this.databaseService}) {
    _listenToLessons();
  }

  List<Lesson> get lessons => _lessons;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<LessonLine> getLessonLines(String lessonId) {
    return _lessonLines[lessonId] ?? [];
  }

  void _listenToLessons({String? groupId}) {
    try {
      _currentGroupId = groupId;
      _lessonsSubscription?.cancel();
      _lessonsSubscription = databaseService.getLessonsStream(groupId: groupId).listen(
        (data) {
          _lessons = data
              .map((item) => Lesson.fromSupabase(item))
              .toList();
          
          // Subscribe to lesson lines for each lesson
          for (var lesson in _lessons) {
            if (lesson.id != null) {
              _listenToLessonLines(lesson.id!);
            }
          }
          
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

  void _listenToLessonLines(String lessonId) {
    // Cancel existing subscription if any
    _lessonLinesSubscriptions[lessonId]?.cancel();
    
    _lessonLinesSubscriptions[lessonId] = databaseService.getLessonLinesStream(lessonId).listen(
      (data) {
        _lessonLines[lessonId] = data
            .map((item) => LessonLine.fromSupabase(item))
            .toList();
        
        // Update the lesson's lines
        final lessonIndex = _lessons.indexWhere((l) => l.id == lessonId);
        if (lessonIndex != -1) {
          _lessons[lessonIndex].lines = _lessonLines[lessonId];
        }
        
        notifyListeners();
      },
      onError: (error) {
        print('Error loading lesson lines for $lessonId: $error');
      },
    );
  }

  void filterByGroup(String? groupId) {
    _listenToLessons(groupId: groupId);
  }

  Future<void> loadLessonsFromServer() async {
    // Lessons are now loaded automatically via stream
    // This method is kept for compatibility
    notifyListeners();
  }

  Future<void> addLesson(Lesson lesson) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await databaseService.addLesson(lesson.toSupabase());
      final lessonId = response['id'].toString();
      
      // Add lesson lines if any
      if (lesson.lines != null && lesson.lines!.isNotEmpty) {
        for (var line in lesson.lines!) {
          line.lessonId = lessonId;
          await databaseService.addLessonLine(line.toSupabase());
        }
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

  Future<void> deleteLesson(String lessonId) async {
    try {
      _isLoading = true;
      notifyListeners();

      await databaseService.deleteLesson(lessonId);
      
      // Cancel lesson lines subscription
      _lessonLinesSubscriptions[lessonId]?.cancel();
      _lessonLinesSubscriptions.remove(lessonId);
      _lessonLines.remove(lessonId);
      
      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteLessonByIndex(int index) async {
    if (index >= 0 && index < _lessons.length) {
      final lessonId = _lessons[index].id;
      if (lessonId != null) {
        await deleteLesson(lessonId);
      }
    }
  }

  void editLesson(BuildContext context, Lesson lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LessonScreen(lesson: lesson),
      ),
    );
  }

  Future<void> updateLesson(Lesson updatedLesson) async {
    try {
      _isLoading = true;
      notifyListeners();

      if (updatedLesson.id == null) {
        throw 'Lesson ID is required for update';
      }

      await databaseService.updateLesson(
        updatedLesson.id!,
        updatedLesson.toSupabase(),
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

  Future<void> updateLessonLine(String lessonLineId, LessonLine updatedLine) async {
    try {
      await databaseService.updateLessonLine(
        lessonLineId,
        updatedLine.toSupabase(),
      );
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> addLessonLine(String lessonId, LessonLine line) async {
    try {
      line.lessonId = lessonId;
      await databaseService.addLessonLine(line.toSupabase());
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> deleteLessonLine(String lessonLineId) async {
    try {
      await databaseService.deleteLessonLine(lessonLineId);
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> batchUpdateAttendance(String lessonId, List<LessonLine> lines) async {
    try {
      _isLoading = true;
      notifyListeners();

      final attendanceData = lines.map((line) => line.toSupabase()).toList();
      await databaseService.batchInsertLessonLines(attendanceData);

      _error = null;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Lesson> getLessonsByGroup(String groupId) {
    return _lessons.where((lesson) => lesson.groupId == groupId).toList();
  }

  Lesson? getLessonById(String id) {
    try {
      return _lessons.firstWhere((lesson) => lesson.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    _lessonsSubscription?.cancel();
    for (var subscription in _lessonLinesSubscriptions.values) {
      subscription.cancel();
    }
    super.dispose();
  }
}