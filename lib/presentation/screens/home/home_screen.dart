import 'package:carwash_app/presentation/controllers/auth_controller.dart';
import 'package:carwash_app/presentation/screens/transaksi/transaksi_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home'), actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            controller.logout(); 
          },
        ),
      ]),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Selamat datang di aplikasi!'),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TransaksiScreen()),
                  );
                },
                child: Text('Transaksi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
