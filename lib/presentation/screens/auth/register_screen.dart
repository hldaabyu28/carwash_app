import 'package:carwash_app/core/theme/asset_theme.dart';
import 'package:carwash_app/core/theme/font_theme.dart';
import 'package:carwash_app/presentation/controllers/auth_controller.dart';
import 'package:carwash_app/presentation/widgets/my_button.dart';
import 'package:carwash_app/presentation/widgets/my_text_input.dart';
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
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 270,
              decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5), BlendMode.darken),
                    image: AssetImage(AssetTheme.cuciMobil),
                    fit: BoxFit.cover),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sign up for your',
                          style: FontTheme.headline1.copyWith(
                            color: Colors.white,
                            fontSize: 24,
                          )),
                      Text('Account',
                          style: FontTheme.headline1.copyWith(
                            color: Colors.white,
                            fontSize: 24,
                          )),
                      Text('Create a new account',
                          style: FontTheme.bodyText1.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  MyTextInput(
                    controller: usernameController,
                    label: 'Username',
                    hintText: 'Masukkan username Anda',
                  ),
                  SizedBox(height: 16),
                  MyTextInput(
                    controller: namaLengkapController,
                    label: 'Nama Lengkap',
                    hintText: 'Masukkan nama lengkap Anda',
                  ),
                  SizedBox(height: 16),
                  MyTextInput.password(
                    controller: passwordController,
                    label: 'Password',
                    hintText: 'Masukkan password Anda',
                  ),
                  SizedBox(height: 20),
                  Obx(() {
                    return controller.isLoading.value
                        ? CircularProgressIndicator()
                        : MyButton(
                            onPressed: () {
                              controller.register(
                                usernameController.text,
                                passwordController.text,
                                namaLengkapController.text,
                              );
                            },
                            label: 'Register',
                          );
                  }),
                  TextButton(
                    onPressed: () => Get.offAllNamed('/login'),
                    child: Text('Sudah punya akun? Login',
                        style: FontTheme.bodyText2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
