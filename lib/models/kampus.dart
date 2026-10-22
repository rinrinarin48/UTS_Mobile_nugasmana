class Kampus {
  final String kode;
  final String namaLengkap;
  final String alamat;

  final String keterangan;

  final bool negeri;

  const Kampus({
    required this.kode,
    required this.namaLengkap,
    required this.alamat,
    required this.keterangan,
    required this.negeri,
  });

  
  static const List<Kampus> negeriDanKedinasan = [
    Kampus(
      kode: 'UB',
      namaLengkap: 'Universitas Brawijaya',
      alamat: 'Jl. Veteran',
      keterangan: 'Sekitar 18 fakultas, antara lain Kedokteran, Teknik, dan FEB',
      negeri: true,
    ),
    Kampus(
      kode: 'UM',
      namaLengkap: 'Universitas Negeri Malang',
      alamat: 'Jl. Semarang No. 5',
      keterangan: 'Unggul di bidang kependidikan, sains, dan teknik',
      negeri: true,
    ),
    Kampus(
      kode: 'UIN',
      namaLengkap: 'UIN Maulana Malik Ibrahim',
      alamat: 'Jl. Gajayana No. 50',
      keterangan: 'Kampus Islam negeri dengan integrasi sains dan agama',
      negeri: true,
    ),
    Kampus(
      kode: 'Polinema',
      namaLengkap: 'Politeknik Negeri Malang',
      alamat: 'Jl. Soekarno Hatta',
      keterangan: 'Fokus pada pendidikan vokasi dan teknologi',
      negeri: true,
    ),
    Kampus(
      kode: 'Poltekkes',
      namaLengkap: 'Poltekkes Kemenkes Malang',
      alamat: 'Jl. Besar Ijen',
      keterangan: 'Jurusan kesehatan seperti keperawatan dan gizi',
      negeri: true,
    ),
  ];

  
  static const List<Kampus> swasta = [
    Kampus(
      kode: 'UMM',
      namaLengkap: 'Universitas Muhammadiyah Malang',
      alamat: 'Jl. Raya Tlogomas',
      keterangan: 'Kampus swasta terbesar dengan akreditasi Unggul',
      negeri: false,
    ),
    Kampus(
      kode: 'BINUS',
      namaLengkap: 'BINUS University @Malang',
      alamat: 'Kawasan Araya',
      keterangan: 'Fokus pada digital technopreneur dan program global',
      negeri: false,
    ),
    Kampus(
      kode: 'UNISMA',
      namaLengkap: 'Universitas Islam Malang',
      alamat: 'Jl. MT Haryono',
      keterangan: 'Kampus swasta besar di bawah naungan NU',
      negeri: false,
    ),
    Kampus(
      kode: 'UNMER',
      namaLengkap: 'Universitas Merdeka Malang',
      alamat: 'Jl. Terusan Dieng',
      keterangan: 'Terkenal dengan Fakultas Hukum dan FEB yang kuat',
      negeri: false,
    ),
    Kampus(
      kode: 'ITN',
      namaLengkap: 'Institut Teknologi Nasional Malang',
      alamat: 'Jl. Bendungan Sigura-gura',
      keterangan: 'Unggul di bidang teknik dan arsitektur',
      negeri: false,
    ),
    Kampus(
      kode: 'Ma Chung',
      namaLengkap: 'Universitas Ma Chung',
      alamat: 'Villa Puncak Tidar',
      keterangan: 'Lingkungan kampus modern dengan program beasiswa',
      negeri: false,
    ),
  ];


  static List<Kampus> get semua => [...negeriDanKedinasan, ...swasta];

  
  static List<String> get kodeUntukFilter =>
      ['Semua', ...semua.map((k) => k.kode)];

  
  static Kampus? cariKode(String kode) {
    for (final k in semua) {
      if (k.kode == kode) return k;
    }
    return null;
  }
}