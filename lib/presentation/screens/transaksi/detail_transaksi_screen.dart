import 'package:carwash_app/models/transaksi_model.dart';
import 'package:flutter/material.dart';

class DetailTransaksi extends StatelessWidget {
  final Transaksi transaksi;

  DetailTransaksi({required this.transaksi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Transaksi'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('No Bukti Transaksi: ${transaksi.noBuktiTransaksi}'),
            Text('No Polisi: ${transaksi.noPolisi}'),
            Text('Pemilik: ${transaksi.pemilik}'),
            Text('Tanggal Transaksi: ${transaksi.tanggalTransaksi}'),
            Text('Jenis Kendaraan: ${transaksi.jenisKendaraan}'),
            Text('Tarif: ${transaksi.tarif}'),
            transaksi.imageUrl.isNotEmpty
                ? Image.network(
                    'http://192.168.1.5/carwash/${transaksi.imageUrl}')
                : Text('Tidak ada gambar'),
          ],
        ),
      ),
    );
  }
}
