class Course {
  final int id;
  final String description;
  final String? tipoAccesso;

  Course({required this.id, required this.description, this.tipoAccesso});

  factory Course.fromMap(Map<String, dynamic> json) => Course(
      id: json['id'],
      description: json['description'],
      tipoAccesso: json['tipoAccesso']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'tipoAccesso': tipoAccesso,
    };
  }
}
