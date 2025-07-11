import 'dart:io';
import 'package:carwash_app/core/constants/api_constant.dart';
import 'package:carwash_app/core/theme/color_theme.dart';
import 'package:carwash_app/core/theme/font_theme.dart';
import 'package:carwash_app/presentation/controllers/transaksi_controller.dart';
import 'package:carwash_app/data/models/create_transaksi_model.dart';
import 'package:carwash_app/data/models/transaksi_model.dart';
import 'package:carwash_app/presentation/widgets/my_button.dart';
import 'package:carwash_app/presentation/widgets/my_text_input.dart';
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
    final apiConstant = ApiConstant.baseUrl;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          "Edit Transaksi",
          style: FontTheme.headline2.copyWith(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.offAllNamed('/transaksi'),
        ),
        backgroundColor: ColorTheme.primaryColor,
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
                  'Memperbarui data...',
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
                          Icons.edit,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Edit Transaksi',
                          style: FontTheme.headline1.copyWith(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Perbarui informasi transaksi',
                          style: FontTheme.bodyText2,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Form Section
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

                  SizedBox(height: 24),

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
                              'Gambar Kendaraan',
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
                                : widget.transaksi.imageUrl != null
                                    ? Image.network(
                                        '${apiConstant}/${widget.transaksi.imageUrl}',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[100],
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.image_not_supported,
                                                  size: 50,
                                                  color: Colors.grey[400],
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                    'Gambar tidak dapat dimuat',
                                                    style: FontTheme.headline2
                                                        .copyWith(
                                                      color: Colors.grey[600],
                                                      fontSize: 14,
                                                    )),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    : Container(
                                        color: Colors.grey[100],
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.image_outlined,
                                              size: 50,
                                              color: Colors.grey[400],
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              'Belum ada gambar',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
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
                  MyButton(
                    label: 'Simpan Perubahan',
                    onPressed: _submitForm,
                    leading: Icon(Icons.save, color: Colors.white),
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
