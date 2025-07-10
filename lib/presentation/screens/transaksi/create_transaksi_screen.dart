import 'dart:io';
import 'package:carwash_app/presentation/screens/transaksi/transaksi_screen.dart';
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
  final TextEditingController jenisKendaraanController = TextEditingController();
  final TextEditingController tarifController = TextEditingController();

  XFile? _image;
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

  Future<void> _pickImage() async {
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
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Pilih Sumber Gambar',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  icon: Icons.photo_library,
                  label: 'Galeri',
                  onTap: () async {
                    Navigator.pop(context);
                    await _selectImageFromSource(ImageSource.gallery);
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.camera_alt,
                  label: 'Kamera',
                  onTap: () async {
                    Navigator.pop(context);
                    await _selectImageFromSource(ImageSource.camera);
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

  Future<void> _selectImageFromSource(ImageSource source) async {
    final picker = ImagePicker();
    setState(() {
      isImageLoading = true;
    });

    try {
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      
      if (pickedFile != null) {
        setState(() {
          _image = pickedFile;
        });
        Get.snackbar(
          'Berhasil',
          'Gambar berhasil dipilih',
          icon: Icon(Icons.check_circle, color: Colors.green),
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade800,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih gambar: $e',
        icon: Icon(Icons.error, color: Colors.red),
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
      );
    } finally {
      setState(() {
        isImageLoading = false;
      });
    }
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
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
        imageUrl: _image,
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
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
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.1),
                          Theme.of(context).primaryColor.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.add_business,
                            size: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Transaksi Baru',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Lengkapi form di bawah untuk membuat transaksi baru',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Form Section
                  Text(
                    'Informasi Transaksi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Masukkan detail transaksi dengan lengkap',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),

                  _buildTextFormField(
                    controller: noBuktiController,
                    label: 'No Bukti Transaksi',
                    hint: 'Masukkan nomor bukti transaksi',
                    icon: Icons.receipt_long,
                    validator: (value) => value!.isEmpty
                        ? 'No Bukti Transaksi tidak boleh kosong'
                        : null,
                  ),
                  SizedBox(height: 16),

                  _buildTextFormField(
                    controller: noPolisiController,
                    label: 'No Polisi',
                    hint: 'Masukkan nomor polisi kendaraan',
                    icon: Icons.local_taxi,
                    validator: (value) =>
                        value!.isEmpty ? 'No Polisi tidak boleh kosong' : null,
                  ),
                  SizedBox(height: 16),

                  _buildTextFormField(
                    controller: pemilikController,
                    label: 'Pemilik Kendaraan',
                    hint: 'Masukkan nama pemilik kendaraan',
                    icon: Icons.person,
                    validator: (value) =>
                        value!.isEmpty ? 'Pemilik tidak boleh kosong' : null,
                  ),
                  SizedBox(height: 16),

                  _buildTextFormField(
                    controller: tanggalController,
                    label: 'Tanggal Transaksi',
                    hint: 'Pilih tanggal transaksi',
                    icon: Icons.calendar_today,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: child!,
                          );
                        },
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
                  SizedBox(height: 16),

                  _buildTextFormField(
                    controller: jenisKendaraanController,
                    label: 'Jenis Kendaraan',
                    hint: 'Masukkan jenis kendaraan (Motor/Mobil)',
                    icon: Icons.directions_car,
                    validator: (value) => value!.isEmpty
                        ? 'Jenis Kendaraan tidak boleh kosong'
                        : null,
                  ),
                  SizedBox(height: 16),

                  _buildTextFormField(
                    controller: tarifController,
                    label: 'Tarif',
                    hint: 'Masukkan tarif cuci (Rp)',
                    icon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Tarif tidak boleh kosong' : null,
                  ),

                  SizedBox(height: 32),

                  // Image Section
                  Text(
                    'Dokumentasi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tambahkan foto kendaraan',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),

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
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _image != null
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: isImageLoading
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(height: 8),
                                      Text(
                                        'Memuat gambar...',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : _image == null
                                  ? Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.image_outlined,
                                          size: 50,
                                          color: Colors.grey[400],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Belum ada gambar dipilih',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Tap tombol di bawah untuk menambah foto',
                                          style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(
                                        File(_image!.path),
                                        width: double.infinity,
                                        height: 196,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _pickImage,
                            icon: Icon(
                              _image != null ? Icons.edit : Icons.add_a_photo,
                              size: 20,
                            ),
                            label: Text(
                              _image != null ? 'Ganti Gambar' : 'Pilih Gambar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
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
                        shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
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