class Transaksi {
  final int id;
  final String noBuktiTransaksi;
  final String noPolisi;
  final String pemilik;
  final String tanggalTransaksi;
  final String jenisKendaraan;
  final double tarif;
  final String imageUrl;

  Transaksi({
    required this.id,
    required this.noBuktiTransaksi,
    required this.noPolisi,
    required this.pemilik,
    required this.tanggalTransaksi,
    required this.jenisKendaraan,
    required this.tarif,
    required this.imageUrl,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'] != null ? int.parse(json['id'].toString()) : 0, // Parse as integer with default value of 0 if null
      noBuktiTransaksi:
          json['noBuktiTransaksi'] ?? '', // Default empty string if null
      noPolisi: json['noPolisi'] ?? '', // Default empty string if null
      pemilik: json['pemilik'] ?? '', // Default empty string if null
      tanggalTransaksi:
          json['tanggalTransaksi'] ?? '', // Default empty string if null
      jenisKendaraan:
          json['jenisKendaraan'] ?? '', // Default empty string if null
      tarif: json['tarif'] != null
          ? double.parse(json['tarif'].toString())
          : 0.0, // Parse only if not null
      imageUrl: json['imageUrl'] ?? '', // Default empty string if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'noBuktiTransaksi': noBuktiTransaksi,
      'noPolisi': noPolisi,
      'pemilik': pemilik,
      'tanggalTransaksi': tanggalTransaksi,
      'jenisKendaraan': jenisKendaraan,
      'tarif': tarif,
      'imageUrl': imageUrl,
    };
  }
}
