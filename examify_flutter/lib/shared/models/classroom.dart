import 'user.dart';

class Classroom {
  final int id;
  final String name;
  final String joinCode;
  final String? description;
  final User? teacher;

  Classroom({
    required this.id,
    required this.name,
    required this.joinCode,
    this.description,
    this.teacher,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'],
      name: json['name'],
      joinCode: json['join_code'] ?? '',
      description: json['description'],
      teacher: json['teacher'] != null ? User.fromJson(json['teacher']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'join_code': joinCode,
      'description': description,
      'teacher': teacher?.toJson(),
    };
  }
}
