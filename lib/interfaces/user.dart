// user interface

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.avatar = 'https://via.placeholder.com/500',
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: '${json['id']}',
      name: json['name'],
      email: json['email'],
      password: json['password'],
      avatar: json['avatar'],
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }
}
