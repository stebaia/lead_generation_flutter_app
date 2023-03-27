import 'dart:convert';

class User {
  final int? id;
  final String email;
  final String password;
  final int userType;
  int? manifestationId;
  String? manifestationName;
  int? courseId;
  String? courseName;

  User(
      {this.id,
      required this.email,
      required this.password,
      required this.userType,
      this.manifestationId,
      this.manifestationName,
      this.courseId,
      this.courseName});

  factory User.fromMap(Map<String, dynamic> json) => User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      userType: json['userType'],
      manifestationId: json['manifestationId'],
      manifestationName: json['manifestationName'],
      courseId: json['courseId'],
      courseName: json['courseName']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'userType': userType,
      'manifestationId': manifestationId,
      'manifestationName': manifestationName,
      'courseId': courseId,
      'courseName': courseName
    };
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, password: $password, userType: $userType, manifestationId: $manifestationId, manifestationName: $manifestationName, courseId: $courseId, courseName: $courseName}';
  }
}
