import 'package:carwash_app/core/theme/color_theme.dart';
import 'package:carwash_app/core/theme/font_theme.dart';
import 'package:carwash_app/presentation/controllers/transaksi_controller.dart';
import 'package:carwash_app/presentation/screens/transaksi/create_transaksi_screen.dart';
import 'package:carwash_app/presentation/screens/transaksi/detail_transaksi_screen.dart';
import 'package:carwash_app/presentation/screens/transaksi/update_transaksi.dart';
import 'package:carwash_app/presentation/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransaksiScreen extends StatelessWidget {
  final TransaksiController controller = Get.put(TransaksiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.offAllNamed('/home'),
        ),
        title: Text('Transaksi',
            style: FontTheme.headline1.copyWith(
              color: Colors.white,
              fontSize: 20,
            )),
        backgroundColor: ColorTheme.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Statistics
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ColorTheme.primaryColor, ColorTheme.secondaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Obx(() => Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Transaksi',
                          controller.transaksiList.length.toString(),
                          Icons.receipt_long,
                          Colors.white,
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          'Hari Ini',
                          _getTodayTransactionCount().toString(),
                          Icons.today,
                          Colors.white,
                        ),
                      ),
                    ],
                  )),
            ),
          ),

          // Transaction List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                controller.fetchTransaksi();
              },
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Memuat transaksi...',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.transaksiList.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 16),
                          Text('Belum ada transaksi',
                              style: FontTheme.headline1),
                          SizedBox(height: 8),
                          Text('Tambahkan transaksi pertama Anda',
                              style: FontTheme.bodyText1),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: controller.transaksiList.length,
                  itemBuilder: (context, index) {
                    final transaksi = controller.transaksiList[index];
                    return _buildTransactionCard(transaksi, index);
                  },
                );
              }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(CreateTransaksiScreen());
        },
        icon: Icon(Icons.add),
        label: Text('Tambah'),
        backgroundColor: ColorTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: FontTheme.headline1.copyWith(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  style: FontTheme.bodyText1.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(dynamic transaksi, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => Get.to(DetailTransaksi(transaksi: transaksi)),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: ColorTheme.secondaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.local_car_wash,
                          color: ColorTheme.primaryColor,
                          size: 20,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaksi.pemilik,
                            style: FontTheme.headline1.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            transaksi.noBuktiTransaksi,
                            style: FontTheme.bodyText1.copyWith(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Selesai',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Details Row
                Row(
                  children: [
                    Expanded(
                      child: _buildDetailItem(
                        Icons.directions_car,
                        'No. Polisi',
                        transaksi.noPolisi,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildDetailItem(
                        Icons.attach_money,
                        'Tarif',
                        'Rp ${_formatCurrency(transaksi.tarif)}',
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () =>
                          Get.to(UpdateTransaksiScreen(transaksi: transaksi)),
                      icon: Icon(Icons.edit, size: 16),
                      label: Text('Edit'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue[600],
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                    ),
                    SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () =>
                          _showDeleteDialog(Get.context!, transaksi.id),
                      icon: Icon(Icons.delete, size: 16),
                      label: Text('Hapus'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red[600],
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red[600]),
            SizedBox(width: 8),
            Text('Konfirmasi Hapus'),
          ],
        ),
        content: Text(
            'Apakah Anda yakin ingin menghapus transaksi ini? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteTransaksi(id);
            },
            child: Text('Hapus'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  int _getTodayTransactionCount() {
    final today = DateTime.now();
    return controller.transaksiList.where((transaksi) {
      return true;
    }).length;
  }

  String _formatCurrency(dynamic amount) {
    if (amount == null) return '0';
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
