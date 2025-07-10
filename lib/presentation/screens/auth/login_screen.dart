import 'package:carwash_app/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
            SizedBox(height: 20),
            Obx(() {
              return controller.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () {
                        final username = usernameController.text.trim();
                        final password = passwordController.text.trim();

                        controller.login(
                            username, password); // Panggil fungsi login
                      },
                      child: Text('Login'),
                    );
            }),
            TextButton(
              onPressed: (){
                Get.toNamed('/register');
              },
              child: Text('Belum punya akun? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
