enum UserRole { teacher, student }

class User {
  final int id;
  final String name;
  final String? email;
  final UserRole role;

  User({required this.id, required this.name, this.email, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? 'Unknown User',
      email: json['email'],
      role: (json['role'] ?? 'student') == 'teacher'
          ? UserRole.teacher
          : UserRole.student,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role == UserRole.teacher ? 'teacher' : 'student',
    };
  }
}
