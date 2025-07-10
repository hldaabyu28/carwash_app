import 'dart:io';
import 'package:carwash_app/presentation/screens/transaksi/transaksi_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carwash_app/presentation/controllers/transaksi_controller.dart';
import 'package:carwash_app/models/create_transaksi_model.dart';

class CreateTransaksiScreen extends StatefulWidget {
  @override
  _CreateTransaksiScreenState createState() => _CreateTransaksiScreenState();
}

class _CreateTransaksiScreenState extends State<CreateTransaksiScreen> {
  final TransaksiController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController noBuktiController = TextEditingController();
  final TextEditingController noPolisiController = TextEditingController();
  final TextEditingController pemilikController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController jenisKendaraanController =
      TextEditingController();
  final TextEditingController tarifController = TextEditingController();

  XFile? _image;

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    noBuktiController.dispose();
    noPolisiController.dispose();
    pemilikController.dispose();
    tanggalController.dispose();
    jenisKendaraanController.dispose();
    tarifController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = pickedFile;
        });
      } else {
        Get.snackbar('Info', 'Tidak ada gambar yang dipilih.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memilih gambar: $e');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        Get.snackbar('Error', 'Silakan pilih gambar terlebih dahulu.');
        return;
      }

      final transaksi = CreateTransaksiModel(
        noBuktiTransaksi: noBuktiController.text,
        noPolisi: noPolisiController.text,
        pemilik: pemilikController.text,
        tanggalTransaksi: tanggalController.text,
        jenisKendaraan: jenisKendaraanController.text,
        tarif: tarifController.text,
        imageUrl: _image,
      );

      try {
        final success = await controller.createTransaksi(transaksi);
        if (success) {
          Get.snackbar('Success', 'Transaksi berhasil disimpan.');
          Get.offAllNamed('/transaksi');
        }
      } catch (e) {
        Get.snackbar('Error', 'Terjadi kesalahan: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buat Transaksi Baru"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: noBuktiController,
                decoration: InputDecoration(labelText: "No Bukti Transaksi"),
                validator: (value) => value!.isEmpty
                    ? 'No Bukti Transaksi tidak boleh kosong'
                    : null,
              ),
              TextFormField(
                controller: noPolisiController,
                decoration: InputDecoration(labelText: "No Polisi"),
                validator: (value) =>
                    value!.isEmpty ? 'No Polisi tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: pemilikController,
                decoration: InputDecoration(labelText: "Pemilik"),
                validator: (value) =>
                    value!.isEmpty ? 'Pemilik tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: tanggalController,
                decoration: InputDecoration(labelText: "Tanggal Transaksi"),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      tanggalController.text =
                          pickedDate.toIso8601String().split('T')[0];
                    });
                  }
                },
                validator: (value) => value!.isEmpty
                    ? 'Tanggal Transaksi tidak boleh kosong'
                    : null,
              ),
              TextFormField(
                controller: jenisKendaraanController,
                decoration: InputDecoration(labelText: "Jenis Kendaraan"),
                validator: (value) => value!.isEmpty
                    ? 'Jenis Kendaraan tidak boleh kosong'
                    : null,
              ),
              TextFormField(
                controller: tarifController,
                decoration: InputDecoration(labelText: "Tarif"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Tarif tidak boleh kosong' : null,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pilih Gambar'),
              ),
              SizedBox(height: 10),
              _image == null
                  ? Text("Gambar belum dipilih",
                      style: TextStyle(color: Colors.grey))
                  : Image.file(
                      File(_image!.path),
                      height: 100,
                    ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Simpan Transaksi"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
