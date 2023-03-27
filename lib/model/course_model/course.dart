class Course {
  final int id;
  final String description;

  Course({required this.id, required this.description});

  factory Course.fromMap(Map<String, dynamic> json) =>
      Course(id: json['id'], description: json['description']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
    };
  }
}
