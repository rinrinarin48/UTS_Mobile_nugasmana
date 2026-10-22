class Cafe {
  final String id;
  final String nama;
  final String area;
  final List<String> kampusTerdekat;
  final String alamat;
  final String jamBuka;
  final bool buka24Jam;
  final int hargaMin;
  final int hargaMax;
  final List<String> fasilitas;


  final int skorNugas;

  final String deskripsi;
  final String gambar;

  
  final String sumber;

  const Cafe({
    required this.id,
    required this.nama,
    required this.area,
    required this.kampusTerdekat,
    required this.alamat,
    required this.jamBuka,
    required this.buka24Jam,
    required this.hargaMin,
    required this.hargaMax,
    required this.fasilitas,
    required this.skorNugas,
    required this.deskripsi,
    required this.gambar,
    required this.sumber,
  });

  factory Cafe.fromJson(Map<String, dynamic> json) {
    return Cafe(
      id: json['id'] as String,
      nama: json['nama'] as String,
      area: json['area'] as String,
      kampusTerdekat: List<String>.from(json['kampusTerdekat'] ?? const []),
      alamat: json['alamat'] as String,
      jamBuka: json['jamBuka'] as String,
      buka24Jam: json['buka24Jam'] as bool,
      hargaMin: json['hargaMin'] as int,
      hargaMax: json['hargaMax'] as int,
      fasilitas: List<String>.from(json['fasilitas'] ?? const []),
      skorNugas: json['skorNugas'] as int,
      deskripsi: json['deskripsi'] as String,
      gambar: json['gambar'] as String,
      sumber: json['sumber'] as String,
    );
  }

  
  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'area': area,
        'kampusTerdekat': kampusTerdekat,
        'alamat': alamat,
        'jamBuka': jamBuka,
        'buka24Jam': buka24Jam,
        'hargaMin': hargaMin,
        'hargaMax': hargaMax,
        'fasilitas': fasilitas,
        'skorNugas': skorNugas,
        'deskripsi': deskripsi,
        'gambar': gambar,
        'sumber': sumber,
      };


  String get kisaranHarga =>
      'Rp ${(hargaMin / 1000).round()}rb - ${(hargaMax / 1000).round()}rb';

  
  String get kisaranHargaPanjang =>
      'Rp ${_format(hargaMin)} - Rp ${_format(hargaMax)}';

  
  String get keteranganSkor {
    if (skorNugas >= 9) return 'Sangat cocok untuk nugas lama';
    if (skorNugas >= 7) return 'Cocok untuk nugas beberapa jam';
    return 'Cukup untuk nugas singkat';
  }

  static String _format(int angka) {
    final teks = angka.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < teks.length; i++) {
      if (i > 0 && (teks.length - i) % 3 == 0) buffer.write('.');
      buffer.write(teks[i]);
    }
    return buffer.toString();
  }
}

class Kategori {
  final String nama;
  final String ikon;
  final bool Function(Cafe) filter;

  const Kategori({
    required this.nama,
    required this.ikon,
    required this.filter,
  });

  static final List<Kategori> semua = [
    Kategori(
      nama: 'Ada WiFi',
      ikon: 'wifi',
      filter: (c) => c.fasilitas.contains('WiFi'),
    ),
    Kategori(
      nama: 'Banyak Colokan',
      ikon: 'power',
      filter: (c) => c.fasilitas.contains('Colokan'),
    ),
    Kategori(
      nama: 'Buka 24 Jam',
      ikon: 'clock',
      filter: (c) => c.buka24Jam,
    ),
    Kategori(
      nama: 'Harga Mahasiswa',
      ikon: 'wallet',
      filter: (c) => c.hargaMin <= 12000,
    ),
    Kategori(
      nama: 'Buka Sampai Malam',
      ikon: 'moon',
      filter: (c) =>
          c.buka24Jam ||
          const ['00.00', '01.00', '23.30', '23.00']
              .contains(c.jamBuka.split(' - ').last),
    ),
    Kategori(
      nama: 'Ada Mushola',
      ikon: 'mosque',
      filter: (c) => c.fasilitas.contains('Mushola'),
    ),
  ];
}
