import 'dart:io';
import 'package:carwash_app/presentation/controllers/transaksi_controller.dart';
import 'package:carwash_app/data/models/create_transaksi_model.dart';
import 'package:carwash_app/data/models/transaksi_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateTransaksiScreen extends StatefulWidget {
  final Transaksi transaksi;

  UpdateTransaksiScreen({super.key, required this.transaksi});

  @override
  State<UpdateTransaksiScreen> createState() => _UpdateTransaksiScreenState();
}

class _UpdateTransaksiScreenState extends State<UpdateTransaksiScreen> {
  final _formKey = GlobalKey<FormState>();
  final TransaksiController controller = Get.find();

  late TextEditingController noBuktiController;
  late TextEditingController noPolisiController;
  late TextEditingController pemilikController;
  late TextEditingController tanggalController;
  late TextEditingController jenisKendaraanController;
  late TextEditingController tarifController;

  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    noBuktiController =
        TextEditingController(text: widget.transaksi.noBuktiTransaksi);
    noPolisiController = TextEditingController(text: widget.transaksi.noPolisi);
    pemilikController = TextEditingController(text: widget.transaksi.pemilik);
    tanggalController =
        TextEditingController(text: widget.transaksi.tanggalTransaksi);
    jenisKendaraanController =
        TextEditingController(text: widget.transaksi.jenisKendaraan);
    tarifController =
        TextEditingController(text: widget.transaksi.tarif.toString());
  }

  @override
  void dispose() {
    noBuktiController.dispose();
    noPolisiController.dispose();
    pemilikController.dispose();
    tanggalController.dispose();
    jenisKendaraanController.dispose();
    tarifController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Membuat CreateTransaksiModel yang sesuai
      final updatedTransaksi = CreateTransaksiModel(
        noBuktiTransaksi: noBuktiController.text,
        noPolisi: noPolisiController.text,
        pemilik: pemilikController.text,
        tanggalTransaksi: tanggalController.text,
        jenisKendaraan: jenisKendaraanController.text,
        tarif: double.tryParse(tarifController.text)?.toString() ?? '0.0',
        imageUrl: _selectedImage, // gunakan XFile yang baru dipilih
      );

      final success = await controller.updateTransaksi(
          widget.transaksi.id, updatedTransaksi);
      if (success) {
        Get.offAllNamed('/transaksi');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Transaksi")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: noBuktiController,
                  decoration: const InputDecoration(
                    labelText: 'No Bukti Transaksi',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: noPolisiController,
                  decoration: const InputDecoration(
                    labelText: 'No Polisi',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: pemilikController,
                  decoration: const InputDecoration(
                    labelText: 'Pemilik',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: tanggalController,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Transaksi',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: jenisKendaraanController,
                  decoration: const InputDecoration(
                    labelText: 'Jenis Kendaraan',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: tarifController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Tarif',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 20),

                // Image Section
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gambar Transaksi',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        if (_selectedImage != null)
                          Image.file(
                            File(_selectedImage!.path),
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        else if (widget.transaksi.imageUrl != null)
                          Image.network(
                            'http://192.168.1.5/carwash/${widget.transaksi.imageUrl}',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 150,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported,
                                    size: 50),
                              );
                            },
                          )
                        else
                          Container(
                            height: 150,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image, size: 50),
                            ),
                          ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Pilih Gambar Baru'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Simpan Perubahan"),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
