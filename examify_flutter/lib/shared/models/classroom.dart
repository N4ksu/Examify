import 'user.dart';

class Classroom {
  final int id;
  final String name;
  final String code;
  final String? description;
  final User? teacher;

  Classroom({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    this.teacher,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      description: json['description'],
      teacher: json['teacher'] != null ? User.fromJson(json['teacher']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'teacher': teacher?.toJson(),
    };
  }
}
