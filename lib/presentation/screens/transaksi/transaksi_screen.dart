import 'package:carwash_app/presentation/controllers/transaksi_controller.dart';
import 'package:carwash_app/presentation/screens/transaksi/create_transaksi_screen.dart';
import 'package:carwash_app/presentation/screens/transaksi/detail_transaksi_screen.dart';
import 'package:carwash_app/presentation/screens/transaksi/update_transaksi.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransaksiScreen extends StatelessWidget {
  final TransaksiController controller = Get.put(TransaksiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed('/home')
        ),
        title: Text('Transaksi'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              controller.fetchTransaksi();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: controller.transaksiList.length,
          itemBuilder: (context, index) {
            final transaksi = controller.transaksiList[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text(transaksi.pemilik),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaksi.noBuktiTransaksi),
                    Text(
                      'No. Polisi: ${transaksi.noPolisi}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      'Tarif: Rp ${transaksi.tarif}',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onTap: () => Get.to(DetailTransaksi(transaksi: transaksi)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => Get.to(UpdateTransaksiScreen(transaksi: transaksi)),
                      tooltip: 'Edit Transaksi',
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(context, transaksi.id),
                      tooltip: 'Hapus Transaksi',
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(CreateTransaksiScreen());
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    Get.dialog(
      AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus transaksi ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteTransaksi(id);
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}