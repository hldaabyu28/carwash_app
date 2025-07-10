import 'dart:convert';

import 'package:carwash_app/models/create_transaksi_model.dart';
import 'package:carwash_app/services/transaksi_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/transaksi_model.dart';

class TransaksiController extends GetxController {
  final TransaksiService transaksiService = TransaksiService();
  var transaksiList = <Transaksi>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransaksi();
  }

  Future<bool> createTransaksi(CreateTransaksiModel transaksi) async {
    isLoading(true); // Set loading state
    try {
      // Konversi gambar ke base64 jika ada gambar
      if (transaksi.imageUrl != null) {
        final bytes = await transaksi.imageUrl!.readAsBytes();
        transaksi.imageBase64 = base64Encode(bytes);
      }

      // Kirim permintaan ke layanan transaksi
      await transaksiService.createTransaksi(transaksi, transaksi.imageUrl);
      print('Transaksi created: ${transaksi.toJson()}');

      // Fetch data transaksi terbaru setelah berhasil menambahkan
      fetchTransaksi();

      // Menampilkan pesan sukses
      return true;
    } catch (e) {
      print('Error creating transaksi: $e');
      print('StackTrace: ${e.toString()}');

      Get.snackbar("Gagal", "Tidak dapat menambahkan transaksi",
          snackPosition: SnackPosition.BOTTOM);

      return false;
    } finally {
      isLoading(false);
    }
  }

  void fetchTransaksi() async {
    try {
      isLoading(true);
      var transaksi = await transaksiService.fetchTransaksi();
      print('Transaksi fetched: ${transaksi.length}');
      transaksiList.assignAll(transaksi);
    } finally {
      isLoading(false);
    }
  }

  void deleteTransaksi(int id) async {
    try {
      await transaksiService.deleteTransaksi(id);
      transaksiList.removeWhere((transaksi) => transaksi.id == id);
      Get.snackbar('Berhasil', 'Transaksi dihapus',
          backgroundColor: Colors.greenAccent.shade400);
    } catch (e) {
      Get.snackbar('Gagal', 'Tidak dapat menghapus transaksi');
    }
  }

  Future<bool> updateTransaksi(int id, CreateTransaksiModel transaksi) async {
    isLoading(true); // Set loading state
    try {
      // Konversi gambar ke base64 jika ada gambar
      if (transaksi.imageUrl != null) {
        final bytes = await transaksi.imageUrl!.readAsBytes();
        transaksi.imageBase64 = base64Encode(bytes);
      }

      // Kirim permintaan update ke layanan transaksi
      await transaksiService.updateTransaksi(id, transaksi, transaksi.imageUrl);
      print('Transaksi updated: ${transaksi.toJson()}');

      // Fetch data transaksi terbaru setelah berhasil mengupdate
      fetchTransaksi();

      // Menampilkan pesan sukses
      Get.snackbar("Berhasil", "Transaksi berhasil diperbarui",
          backgroundColor: Colors.greenAccent.shade400);

      return true;
    } catch (e) {
      print('Error updating transaksi: $e');
      print('StackTrace: ${e.toString()}');

      Get.snackbar("Gagal", "Tidak dapat memperbarui transaksi",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.shade400);

      return false;
    } finally {
      isLoading(false);
    }
  }
}
