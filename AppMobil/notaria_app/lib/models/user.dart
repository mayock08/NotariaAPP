class User {
  final String email;
  final String fullName;
  final String token;
  final DateTime expiresAt;

  User({
    required this.email,
    required this.fullName,
    required this.token,
    required this.expiresAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      token: json['token'] ?? '',
      expiresAt: DateTime.parse(json['expiresAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'fullName': fullName,
      'token': token,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }
}
