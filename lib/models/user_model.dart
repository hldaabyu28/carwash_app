class User {
  final String username;
  final String password;
  final String? name;

  User({required this.username, required this.password, this.name});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'nama_lengkap': name,
    };
  }
}
