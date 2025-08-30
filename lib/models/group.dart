class Group {
  String? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  Group({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory Group.fromSupabase(Map<String, dynamic> data) {
    return Group(
      id: data['id']?.toString(),
      name: data['name'] as String?,
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
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Group{id: $id, name: $name}';
  }
}
