import 'dart:convert';
import 'package:carwash_app/data/models/create_transaksi_model.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/transaksi_model.dart';

class TransaksiService {
  static const String baseUrl = "http://192.168.1.5/carwash";

  Future<void> createTransaksi(
      CreateTransaksiModel transaksi, XFile? image) async {
    final uri = Uri.parse('$baseUrl/create_transaksi.php');

    try {
      // Membuat permintaan multipart
      var request = http.MultipartRequest('POST', uri);

      // Menambahkan field
      request.fields['noBuktiTransaksi'] = transaksi.noBuktiTransaksi;
      request.fields['noPolisi'] = transaksi.noPolisi;
      request.fields['pemilik'] = transaksi.pemilik;
      request.fields['tanggalTransaksi'] = transaksi.tanggalTransaksi;
      request.fields['jenisKendaraan'] = transaksi.jenisKendaraan;
      request.fields['tarif'] = transaksi.tarif.toString();

      // Menambahkan file jika tersedia
      if (image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('imageUrl', image.path));
      }

      // Mengirimkan permintaan
      final response = await request.send();

      // Membaca body respons
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        print('Transaksi berhasil ditambahkan.');
        print('Respons: $responseBody');
      } else {
        print('Gagal menambahkan transaksi: ${response.reasonPhrase}');
        print('Detail: $responseBody');
      }
    } catch (e) {
      print('Terjadi kesalahan saat menambahkan transaksi: $e');
    }
  }

  Future<List<Transaksi>> fetchTransaksi() async {
    final response = await http.get(Uri.parse('$baseUrl/get_transaksi.php'));
    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((json) => Transaksi.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data transaksi');
    }
  }

  Future<void> deleteTransaksi(int id) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/delete_transaksi.php?id=$id'));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus transaksi');
    }
  }

   Future<void> updateTransaksi(
      int id, CreateTransaksiModel transaksi, XFile? image) async {
    final uri = Uri.parse('$baseUrl/update_transaksi.php?id=$id');

    try {
      // Membuat permintaan multipart
      var request = http.MultipartRequest('POST', uri);

      // Menambahkan field
      request.fields['id'] = id.toString();
      request.fields['noBuktiTransaksi'] = transaksi.noBuktiTransaksi;
      request.fields['noPolisi'] = transaksi.noPolisi;
      request.fields['pemilik'] = transaksi.pemilik;
      request.fields['tanggalTransaksi'] = transaksi.tanggalTransaksi;
      request.fields['jenisKendaraan'] = transaksi.jenisKendaraan;
      request.fields['tarif'] = transaksi.tarif.toString();

      // Menambahkan file jika tersedia
      if (image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('imageUrl', image.path));
      }

      // Mengirimkan permintaan
      final response = await request.send();

      // Membaca body respons
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print('Transaksi berhasil diperbarui.');
        print('Respons: $responseBody');
      } else {
        print('Gagal memperbarui transaksi: ${response.reasonPhrase}');
        print('Detail: $responseBody');
      }
    } catch (e) {
      print('Terjadi kesalahan saat memperbarui transaksi: $e');
    }
  }

}
