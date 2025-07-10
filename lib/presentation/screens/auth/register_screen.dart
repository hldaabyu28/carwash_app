import 'package:carwash_app/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final namaLengkapController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: namaLengkapController,
              decoration: InputDecoration(labelText: 'Nama Lengkap'),
            ),
            SizedBox(height: 20),
            Obx(() {
              return controller.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        controller.register(
                          usernameController.text,
                          passwordController.text,
                          namaLengkapController.text,
                        );
                      },
                      child: Text('Register'),
                    );
            }),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Sudah punya akun? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
