class LessonLine {
  String? id;
  String? studentId;
  String? studentName;
  String? lessonId;
  bool? paid;
  bool? attended;
  double? amount;
  String? notes;
  DateTime? createdAt;

  LessonLine({
    this.id,
    this.studentId,
    this.studentName,
    this.lessonId,
    this.paid,
    this.attended,
    this.amount,
    this.notes,
    this.createdAt,
  });

  factory LessonLine.fromSupabase(Map<String, dynamic> data) {
    return LessonLine(
      id: data['id']?.toString(),
      studentId: data['student_id'] as String?,
      studentName: data['student_name'] as String?,
      lessonId: data['lesson_id'] as String?,
      paid: data['paid'] as bool?,
      attended: data['attended'] as bool?,
      amount: (data['amount'] as num?)?.toDouble(),
      notes: data['notes'] as String?,
      createdAt: data['created_at'] != null 
          ? DateTime.parse(data['created_at']) 
          : null,
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'student_id': studentId,
      'student_name': studentName,
      'lesson_id': lessonId,
      'paid': paid ?? false,
      'attended': attended ?? false,
      'amount': amount,
      'notes': notes,
    };
  }
}
