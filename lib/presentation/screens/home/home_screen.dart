import 'package:carwash_app/core/theme/color_theme.dart';
import 'package:carwash_app/core/theme/font_theme.dart';
import 'package:carwash_app/presentation/controllers/auth_controller.dart';
import 'package:carwash_app/presentation/screens/settings/setting_screen.dart';
import 'package:carwash_app/presentation/screens/transaksi/transaksi_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorTheme.primaryColor,
                      ColorTheme.secondaryColor
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: ColorTheme.primaryColor.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang,',
                      style: FontTheme.headline2.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Obx(() => Text(
                          controller.currentUser.value?.username ?? 'User',
                          style: FontTheme.bodyText2
                              .copyWith(color: Colors.white, fontSize: 18),
                        )),
                    SizedBox(height: 10),
                    Text(
                      'Semoga hari Anda menyenangkan!',
                      style: FontTheme.bodyText1.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Quick Actions Section
              Text(
                'Menu Utama',
                style: FontTheme.headline2.copyWith(),
              ),
              SizedBox(height: 15),

              // Menu Grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.8,
                  children: [
                    _buildMenuCard(
                      icon: Icons.local_car_wash,
                      title: 'Transaksi',
                      subtitle: 'Kelola transaksi',
                      color: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransaksiScreen(),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.history,
                      title: 'Riwayat',
                      subtitle: 'Lihat riwayat',
                      color: Colors.orange,
                      onTap: () {
                        // TODO: Navigate to history screen
                        Get.snackbar(
                          'Info',
                          'Fitur riwayat akan segera tersedia',
                          backgroundColor: Colors.blue[100],
                          colorText: Colors.blue[800],
                        );
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.person,
                      title: 'Profile',
                      subtitle: 'Kelola profil',
                      color: Colors.purple,
                      onTap: () {
                        // TODO: Navigate to profile screen
                        Get.snackbar(
                          'Info',
                          'Fitur profil akan segera tersedia',
                          backgroundColor: Colors.blue[100],
                          colorText: Colors.blue[800],
                        );
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.settings,
                      title: 'Pengaturan',
                      subtitle: 'Atur aplikasi',
                      color: Colors.grey,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: FontTheme.headline1.copyWith(
                  fontSize: 16
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: FontTheme.bodyText2.copyWith(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
