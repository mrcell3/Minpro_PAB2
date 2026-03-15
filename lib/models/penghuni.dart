class Penghuni {
  final String id;
  final String nama;
  final String nomorKamar;
  final String nomorHP;
  final String tanggalMasuk;
  final String hargaSewa;
  final String? userId;

  Penghuni({
    required this.id,
    required this.nama,
    required this.nomorKamar,
    required this.nomorHP,
    required this.tanggalMasuk,
    required this.hargaSewa,
    this.userId,
  });

  factory Penghuni.fromJson(Map<String, dynamic> json) {
    return Penghuni(
      id: json['id'].toString(),
      nama: json['nama'] ?? '',
      nomorKamar: json['nomor_kamar'] ?? '',
      nomorHP: json['nomor_hp'] ?? '',
      tanggalMasuk: json['tanggal_masuk'] ?? '',
      hargaSewa: json['harga_sewa'].toString(),
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'nomor_kamar': nomorKamar,
      'nomor_hp': nomorHP,
      'tanggal_masuk': tanggalMasuk,
      'harga_sewa': int.tryParse(hargaSewa) ?? 0,
    };
  }
}