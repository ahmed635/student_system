import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  String? get userId => _client.auth.currentUser?.id;

  // Groups CRUD operations
  Future<List<Map<String, dynamic>>> getGroups() async {
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client
        .from('groups')
        .select('*')
        .eq('user_id', userId!)
        .order('created_at', ascending: false) as List<dynamic>;

    return response.cast<Map<String, dynamic>>();
  }

  Stream<List<Map<String, dynamic>>> getGroupsStream() {
    if (userId == null) throw Exception('User not authenticated');

    return _client
        .from('groups')
        .stream(primaryKey: ['id']).map((data) {
          // Filter and sort data manually since stream doesn't support complex queries
          List<Map<String, dynamic>> filtered = data
              .cast<Map<String, dynamic>>()
              .where((item) => item['user_id'] == userId)
              .toList();
          
          // Sort by created_at descending
          filtered.sort((a, b) {
            final dateA = DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(1970);
            final dateB = DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(1970);
            return dateB.compareTo(dateA);
          });
          
          return filtered;
        });
  }

  Future<Map<String, dynamic>> addGroup(Map<String, dynamic> groupData) async {
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client.from('groups').insert({
      ...groupData,
      'user_id': userId,
    }).select().single();

    return response;
  }

  Future<void> updateGroup(String groupId, Map<String, dynamic> groupData) async {
    if (userId == null) throw Exception('User not authenticated');

    await _client
        .from('groups')
        .update(groupData)
        .eq('id', groupId)
        .eq('user_id', userId!);
  }

  Future<void> deleteGroup(String groupId) async {
    if (userId == null) throw Exception('User not authenticated');

    // Delete related students first
    await _client
        .from('students')
        .delete()
        .eq('group_id', groupId)
        .eq('user_id', userId!);

    // Delete related lessons
    await _client
        .from('lessons')
        .delete()
        .eq('group_id', groupId)
        .eq('user_id', userId!);

    // Delete the group
    await _client
        .from('groups')
        .delete()
        .eq('id', groupId)
        .eq('user_id', userId!);
  }

  // Students CRUD operations
  Future<List<Map<String, dynamic>>> getStudents({String? groupId}) async {
    if (userId == null) throw Exception('User not authenticated');

    var query = _client
        .from('students')
        .select('*')
        .eq('user_id', userId!);

    if (groupId != null) {
      query = query.eq('group_id', groupId);
    }

    final response = await query.order('created_at', ascending: false) as List<dynamic>;
    return response.cast<Map<String, dynamic>>();
  }

  Stream<List<Map<String, dynamic>>> getStudentsStream({String? groupId}) {
    if (userId == null) throw Exception('User not authenticated');

    return _client
        .from('students')
        .stream(primaryKey: ['id']).map((data) {
          // Filter and sort data manually since stream doesn't support complex queries
          List<Map<String, dynamic>> filtered = data
              .cast<Map<String, dynamic>>()
              .where((item) => item['user_id'] == userId)
              .toList();
          
          if (groupId != null) {
            filtered = filtered.where((item) => item['group_id'] == groupId).toList();
          }
          
          // Sort by created_at descending
          filtered.sort((a, b) {
            final dateA = DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(1970);
            final dateB = DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(1970);
            return dateB.compareTo(dateA);
          });
          
          return filtered;
        });
  }

  Future<Map<String, dynamic>> addStudent(Map<String, dynamic> studentData) async {
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client.from('students').insert({
      ...studentData,
      'user_id': userId,
    }).select().single();

    return response;
  }

  Future<void> updateStudent(String studentId, Map<String, dynamic> studentData) async {
    if (userId == null) throw Exception('User not authenticated');

    await _client
        .from('students')
        .update(studentData)
        .eq('id', studentId)
        .eq('user_id', userId!);
  }

  Future<void> deleteStudent(String studentId) async {
    if (userId == null) throw Exception('User not authenticated');

    // Delete related lesson lines first
    await _client
        .from('lesson_lines')
        .delete()
        .eq('student_id', studentId)
        .eq('user_id', userId!);

    // Delete the student
    await _client
        .from('students')
        .delete()
        .eq('id', studentId)
        .eq('user_id', userId!);
  }

  // Lessons CRUD operations
  Future<List<Map<String, dynamic>>> getLessons({String? groupId}) async {
    if (userId == null) throw Exception('User not authenticated');

    var query = _client
        .from('lessons')
        .select('*')
        .eq('user_id', userId!);

    if (groupId != null) {
      query = query.eq('group_id', groupId);
    }

    final response = await query.order('date', ascending: false) as List<dynamic>;
    return response.cast<Map<String, dynamic>>();
  }

  Stream<List<Map<String, dynamic>>> getLessonsStream({String? groupId}) {
    if (userId == null) throw Exception('User not authenticated');

    return _client
        .from('lessons')
        .stream(primaryKey: ['id']).map((data) {
          // Filter and sort data manually since stream doesn't support complex queries
          List<Map<String, dynamic>> filtered = data
              .cast<Map<String, dynamic>>()
              .where((item) => item['user_id'] == userId)
              .toList();
          
          if (groupId != null) {
            filtered = filtered.where((item) => item['group_id'] == groupId).toList();
          }
          
          // Sort by date descending
          filtered.sort((a, b) {
            final dateA = DateTime.tryParse(a['date'] ?? '') ?? DateTime(1970);
            final dateB = DateTime.tryParse(b['date'] ?? '') ?? DateTime(1970);
            return dateB.compareTo(dateA);
          });
          
          return filtered;
        });
  }

  Future<Map<String, dynamic>> addLesson(Map<String, dynamic> lessonData) async {
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client.from('lessons').insert({
      ...lessonData,
      'user_id': userId,
    }).select().single();

    return response;
  }

  Future<void> updateLesson(String lessonId, Map<String, dynamic> lessonData) async {
    if (userId == null) throw Exception('User not authenticated');

    await _client
        .from('lessons')
        .update(lessonData)
        .eq('id', lessonId)
        .eq('user_id', userId!);
  }

  Future<void> deleteLesson(String lessonId) async {
    if (userId == null) throw Exception('User not authenticated');

    // Delete related lesson lines first
    await _client
        .from('lesson_lines')
        .delete()
        .eq('lesson_id', lessonId)
        .eq('user_id', userId!);

    // Delete the lesson
    await _client
        .from('lessons')
        .delete()
        .eq('id', lessonId)
        .eq('user_id', userId!);
  }

  // Lesson Lines CRUD operations
  Future<List<Map<String, dynamic>>> getLessonLines(String lessonId) async {
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client
        .from('lesson_lines')
        .select('*')
        .eq('lesson_id', lessonId)
        .eq('user_id', userId!)
        .order('created_at', ascending: true) as List<dynamic>;

    return response.cast<Map<String, dynamic>>();
  }

  Stream<List<Map<String, dynamic>>> getLessonLinesStream(String lessonId) {
    if (userId == null) throw Exception('User not authenticated');

    return _client
        .from('lesson_lines')
        .stream(primaryKey: ['id']).map((data) {
          // Filter and sort data manually since stream doesn't support complex queries
          List<Map<String, dynamic>> filtered = data
              .cast<Map<String, dynamic>>()
              .where((item) => item['user_id'] == userId && item['lesson_id'] == lessonId)
              .toList();
          
          // Sort by created_at ascending
          filtered.sort((a, b) {
            final dateA = DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(1970);
            final dateB = DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(1970);
            return dateA.compareTo(dateB);
          });
          
          return filtered;
        });
  }

  Future<Map<String, dynamic>> addLessonLine(Map<String, dynamic> lessonLineData) async {
    if (userId == null) throw Exception('User not authenticated');

    final response = await _client.from('lesson_lines').insert({
      ...lessonLineData,
      'user_id': userId,
    }).select().single();

    return response;
  }

  Future<void> updateLessonLine(String lessonLineId, Map<String, dynamic> lessonLineData) async {
    if (userId == null) throw Exception('User not authenticated');

    await _client
        .from('lesson_lines')
        .update(lessonLineData)
        .eq('id', lessonLineId)
        .eq('user_id', userId!);
  }

  Future<void> deleteLessonLine(String lessonLineId) async {
    if (userId == null) throw Exception('User not authenticated');

    await _client
        .from('lesson_lines')
        .delete()
        .eq('id', lessonLineId)
        .eq('user_id', userId!);
  }

  // Batch operations
  Future<void> batchInsertLessonLines(List<Map<String, dynamic>> lessonLinesData) async {
    if (userId == null) throw Exception('User not authenticated');

    final dataWithUserId = lessonLinesData.map((data) => {
      ...data,
      'user_id': userId,
    }).toList();

    await _client.from('lesson_lines').insert(dataWithUserId);
  }
}