import 'package:carwash_app/presentation/screens/auth/login_screen.dart';
import 'package:carwash_app/presentation/screens/auth/register_screen.dart';
import 'package:carwash_app/presentation/screens/home/home_screen.dart';
import 'package:carwash_app/presentation/screens/settings/setting_screen.dart';
import 'package:carwash_app/presentation/screens/splash_screen.dart';
import 'package:carwash_app/presentation/screens/transaksi/create_transaksi_screen.dart';
import 'package:carwash_app/presentation/screens/transaksi/transaksi_screen.dart';
import 'package:get/get.dart';

class AppRoute {
  static final routes = [
    GetPage(name: '/splash', page: () => SplashScreen()), 
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/settings', page: () => SettingsScreen()), 
    GetPage(name: '/register', page: () => RegisterScreen()),
    GetPage(name: '/home', page: () => HomeScreen()),
    GetPage(name: '/transaksi', page: () => TransaksiScreen()),
    GetPage(name: '/create-transaksi', page: () => CreateTransaksiScreen()),
  ];
}
