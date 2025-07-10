import 'dart:convert';
import 'package:carwash_app/core/constants/api_constant.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = ApiConstant.baseUrl;

  Future<Map<String, dynamic>> login(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<Map<String, dynamic>> register(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
