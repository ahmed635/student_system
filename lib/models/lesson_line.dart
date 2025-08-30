import 'package:student_system/models/student.dart';

class LessonLine {
  Student? student;
  bool? paid;
  bool? attended;

  LessonLine({this.student, this.paid, this.attended});
}
