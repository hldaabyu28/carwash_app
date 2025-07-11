import 'dart:io';
import 'package:carwash_app/core/theme/font_theme.dart';
import 'package:carwash_app/presentation/screens/transaksi/transaksi_screen.dart';
import 'package:carwash_app/presentation/widgets/my_button.dart';
import 'package:carwash_app/presentation/widgets/my_text_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carwash_app/presentation/controllers/transaksi_controller.dart';
import 'package:carwash_app/data/models/create_transaksi_model.dart';

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

  XFile? _selectedImage;
  bool isImageLoading = false;

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
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Pilih Sumber Gambar', style: FontTheme.headline2),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  icon: Icons.photo_library,
                  label: 'Galeri',
                  onTap: () async {
                    Navigator.pop(context);
                    final picked = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedImage = picked;
                      });
                    }
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.camera_alt,
                  label: 'Kamera',
                  onTap: () async {
                    Navigator.pop(context);
                    final picked = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                      imageQuality: 85,
                    );
                    if (picked != null) {
                      setState(() {
                        _selectedImage = picked;
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            SizedBox(height: 8),
            Text(
              label,
              style: FontTheme.bodyText1.copyWith(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedImage == null) {
        Get.snackbar(
          'Peringatan',
          'Silakan pilih gambar terlebih dahulu',
          icon: Icon(Icons.warning, color: Colors.orange),
          backgroundColor: Colors.orange.shade50,
          colorText: Colors.orange.shade800,
        );
        return;
      }

      final transaksi = CreateTransaksiModel(
        noBuktiTransaksi: noBuktiController.text,
        noPolisi: noPolisiController.text,
        pemilik: pemilikController.text,
        tanggalTransaksi: tanggalController.text,
        jenisKendaraan: jenisKendaraanController.text,
        tarif: tarifController.text,
        imageUrl: _selectedImage,
      );

      try {
        final success = await controller.createTransaksi(transaksi);
        if (success) {
          Get.snackbar(
            'Berhasil',
            'Transaksi berhasil disimpan',
            icon: Icon(Icons.check_circle, color: Colors.green),
            backgroundColor: Colors.green.shade50,
            colorText: Colors.green.shade800,
          );
          Get.offAllNamed('/transaksi');
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Terjadi kesalahan: $e',
          icon: Icon(Icons.error, color: Colors.red),
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade800,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Buat Transaksi Baru",
          style: FontTheme.headline2.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Menyimpan transaksi...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.add_business_outlined,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Tambah Transaksi Baru',
                          style: FontTheme.headline1.copyWith(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Isi detail transaksi untuk mencatat cuci kendaraan',
                          style: FontTheme.bodyText2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Informasi Transaksi',
                          style: FontTheme.headline2.copyWith(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(height: 20),
                        MyTextInput(
                          controller: noBuktiController,
                          label: 'No Bukti Transaksi',
                          hintText: 'Masukkan no bukti transaksi',
                          prefixIcon: Icon(Icons.receipt_long),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Wajib diisi' : null,
                        ),
                        SizedBox(height: 16),
                        MyTextInput(
                          controller: noPolisiController,
                          label: 'No Polisi',
                          hintText: 'Masukkan no polisi kendaraan',
                          prefixIcon: Icon(Icons.local_taxi),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Wajib diisi' : null,
                        ),
                        SizedBox(height: 16),
                        MyTextInput(
                          controller: pemilikController,
                          label: 'Pemilik',
                          hintText: 'Masukkan nama pemilik',
                          prefixIcon: Icon(Icons.person),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Wajib diisi' : null,
                        ),
                        SizedBox(height: 16),
                        MyTextInput(
                          controller: tanggalController,
                          label: 'Tanggal Transaksi',
                          hintText: 'Masukkan tanggal transaksi',
                          prefixIcon: IconButton(
                              onPressed: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (date != null) {
                                  tanggalController.text =
                                      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                                }
                              },
                              icon: Icon(Icons.calendar_today)),
                          readOnly: true,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Wajib diisi' : null,
                        ),
                        SizedBox(height: 16),
                        MyTextInput(
                          controller: jenisKendaraanController,
                          disabled: false,
                          label: 'Jenis Kendaraan',
                          hintText: 'Masukkan jenis kendaraan',
                          prefixIcon: Icon(Icons.directions_car),
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Wajib diisi' : null,
                        ),
                        SizedBox(height: 16),
                        MyTextInput(
                          controller: tarifController,
                          label: 'Tarif',
                          hintText: 'Masukkan tarif cuci',
                          prefixIcon: Icon(Icons.attach_money),
                          keyboardType: TextInputType.number,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Wajib diisi' : null,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 32),

                  // Image Section
                 Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.image,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Gambar Transaksi',
                              style: FontTheme.headline2.copyWith(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Image Display
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _selectedImage != null
                                ? Image.file(
                                    File(_selectedImage!.path),
                                    fit: BoxFit.cover,
                                  )
                                : Center(
                                    child: Text(
                                      'Tidak ada gambar yang dipilih',
                                      style: FontTheme.bodyText2.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                ),
                               
                          ),
                        ),
                        SizedBox(height: 16),

                        // Pick Image Button
                        MyButton(
                          label: _selectedImage != null
                              ? 'Ganti Gambar'
                              : 'Pilih Gambar',
                          onPressed: _pickImage,
                          leading: Icon(Icons.image, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  
                  SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: Icon(
                        Icons.save,
                        size: 24,
                      ),
                      label: Text(
                        'Simpan Transaksi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        shadowColor:
                            Theme.of(context).primaryColor.withOpacity(0.3),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
