import 'package:student_system/models/group.dart';
import 'package:student_system/models/lesson_line.dart';

class Lesson {
  String? id;
  DateTime? date;
  DateTime? fromTime;
  DateTime? toTime;
  Group? group;
  List<LessonLine>? lines;

  Lesson({
    this.id,
    this.date,
    this.fromTime,
    this.toTime,
    this.group,
    this.lines,
  });
}
