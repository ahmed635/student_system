class Student {
  String? id;
  String? name;
  String? groupId;
  String? groupName;
  String? phone;
  String? email;
  DateTime? createdAt;
  DateTime? updatedAt;

  Student({
    this.id,
    this.name,
    this.groupId,
    this.groupName,
    this.phone,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  factory Student.fromSupabase(Map<String, dynamic> data) {
    return Student(
      id: data['id']?.toString(),
      name: data['name'] as String?,
      groupId: data['group_id'] as String?,
      groupName: data['group_name'] as String?,
      phone: data['phone'] as String?,
      email: data['email'] as String?,
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
      'name': name,
      'group_id': groupId,
      'group_name': groupName,
      'phone': phone,
      'email': email,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Student{id: $id, name: $name, group: $groupName}';
  }
}
