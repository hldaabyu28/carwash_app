import 'package:image_picker/image_picker.dart';

class CreateTransaksiModel {
  String noBuktiTransaksi;
  String noPolisi;
  String pemilik;
  String tanggalTransaksi;
  String jenisKendaraan;
  String tarif;
  XFile? imageUrl;
  String? imageBase64;

  CreateTransaksiModel({
    required this.noBuktiTransaksi,
    required this.noPolisi,
    required this.pemilik,
    required this.tanggalTransaksi,
    required this.jenisKendaraan,
    required this.tarif,
    this.imageUrl,
    this.imageBase64,
  });

  Map<String, dynamic> toJson() => {
        'noBuktiTransaksi': noBuktiTransaksi,
        'noPolisi': noPolisi,
        'pemilik': pemilik,
        'tanggalTransaksi': tanggalTransaksi,
        'jenisKendaraan': jenisKendaraan,
        'tarif': tarif,
        'imageBase64': imageBase64,
      };
}
