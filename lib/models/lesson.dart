import 'package:student_system/models/lesson_line.dart';

class Lesson {
  String? id;
  DateTime? date;
  DateTime? fromTime;
  DateTime? toTime;
  String? groupId;
  String? groupName;
  String? topic;
  String? notes;
  List<LessonLine>? lines;
  DateTime? createdAt;
  DateTime? updatedAt;

  Lesson({
    this.id,
    this.date,
    this.fromTime,
    this.toTime,
    this.groupId,
    this.groupName,
    this.topic,
    this.notes,
    this.lines,
    this.createdAt,
    this.updatedAt,
  });

  factory Lesson.fromSupabase(Map<String, dynamic> data) {
    return Lesson(
      id: data['id']?.toString(),
      date: data['date'] != null ? DateTime.parse(data['date']) : null,
      fromTime: data['from_time'] != null ? DateTime.parse(data['from_time']) : null,
      toTime: data['to_time'] != null ? DateTime.parse(data['to_time']) : null,
      groupId: data['group_id'] as String?,
      groupName: data['group_name'] as String?,
      topic: data['topic'] as String?,
      notes: data['notes'] as String?,
      createdAt: data['created_at'] != null 
          ? DateTime.parse(data['created_at']) 
          : null,
      updatedAt: data['updated_at'] != null 
          ? DateTime.parse(data['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'date': date?.toIso8601String(),
      'from_time': fromTime?.toIso8601String(),
      'to_time': toTime?.toIso8601String(),
      'group_id': groupId,
      'group_name': groupName,
      'topic': topic,
      'notes': notes,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Lesson{id: $id, date: $date, group: $groupName}';
  }
}
