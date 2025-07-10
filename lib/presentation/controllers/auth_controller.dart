import 'package:carwash_app/data/services/auth_service.dart';
import 'package:get/get.dart';
import '../../data/models/user_model.dart';

class AuthController extends GetxController {
  final AuthService authService = AuthService();
  var isLoading = false.obs;

  void login(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Username dan password tidak boleh kosong.");
      return;
    }

    try {
      isLoading(true); // Menandakan loading sedang aktif

      User user = User(username: username, password: password);
      final response = await authService.login(user);

      // Periksa apakah response tidak null dan memiliki key 'success' dan 'message'
      if (response != null &&
          response.containsKey('success') &&
          response.containsKey('message')) {
        if (response['success'] == true) {
          Get.snackbar("Success", response['message']);
          // Pindah ke halaman home setelah login berhasil
          Get.offAllNamed('/home');
        } else {
          throw Exception(response['message'] ?? 'Login gagal');
        }
      } else {
        throw Exception('Response tidak valid');
      }
    } catch (e) {
      // Menampilkan pesan error jika terjadi kesalahan
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false); // Set loading menjadi false setelah proses selesai
    }
  }

  void register(String username, String password, String namaLengkap) async {
    isLoading(true); // Mulai loading
    try {
      final user = User(
        username: username,
        password: password,
        name: namaLengkap,
      );

      final response = await authService.register(user);

      if (response['success'] == true) {
        Get.snackbar("Berhasil", response['message'] ?? "Registrasi berhasil");
        Get.offAllNamed('/login');
      } else {
        Get.snackbar("Gagal", response['message'] ?? "Registrasi gagal");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false); // Selesai loading
    } 
  }

  void logout() {
    Get.offAllNamed('/login');
  }
}
