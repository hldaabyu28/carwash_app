import 'package:carwash_app/core/theme/asset_theme.dart';
import 'package:carwash_app/core/theme/font_theme.dart';
import 'package:carwash_app/presentation/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AssetTheme.splash,
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 20),
              Text('Selamat Datang di Aplikasi Manajemen Carwash',
                  style: FontTheme.headline1, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(
                'Aplikasi ini dirancang untuk memudahkan Anda dalam mengelola transaksi dan layanan carwash.',
                style: FontTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              MyButton(
                label: 'Mulai',
                onPressed: () {
                  // Navigate to the next screen
                  Get.offAllNamed('/login');
                },
                textStyle: FontTheme.buttonText.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
