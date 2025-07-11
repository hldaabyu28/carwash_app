import 'package:carwash_app/core/theme/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carwash_app/routes/app_route.dart'; // sesuaikan dengan path file routes Anda

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Carwash App',
      initialRoute: '/splash',
      getPages: AppRoute.routes,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
