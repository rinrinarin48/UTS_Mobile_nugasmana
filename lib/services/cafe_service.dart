import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/cafe.dart';

/// Lapisan penyedia data aplikasi.
///
/// Saat ini data diambil dari file JSON lokal di folder assets.
/// Pada tahap pengembangan berikutnya, cukup ganti isi [ambilSemuaCafe]
/// dengan permintaan HTTP ke API tanpa mengubah halaman mana pun.
class CafeService {
  static const String _pathAsset = 'assets/data/cafes.json';

  /// URL API yang akan dipakai pada tahap berikutnya.
  /// Contoh: file JSON yang di-host di GitHub (raw) atau MockAPI.io.
  // static const String _urlApi =
  //     'https://raw.githubusercontent.com/username/nugasmana/main/data/cafes.json';

  /// Menyimpan hasil pembacaan agar tidak membaca file berulang kali.
  static List<Cafe>? _cache;

  /// Mengambil seluruh data cafe dari file JSON lokal.
  static Future<List<Cafe>> ambilSemuaCafe() async {
    if (_cache != null) return _cache!;

    final String isiFile = await rootBundle.loadString(_pathAsset);
    final List<dynamic> data = jsonDecode(isiFile) as List<dynamic>;
    _cache = data
        .map((item) => Cafe.fromJson(item as Map<String, dynamic>))
        .toList();
    return _cache!;
  }

  // ---------------------------------------------------------------------
  // Versi API untuk tahap pengembangan berikutnya.
  // Aktifkan package http pada pubspec.yaml, lalu gunakan kode di bawah ini
  // menggantikan metode ambilSemuaCafe() di atas.
  //
  // static Future<List<Cafe>> ambilSemuaCafe() async {
  //   final res = await http.get(Uri.parse(_urlApi));
  //   if (res.statusCode == 200) {
  //     final List data = jsonDecode(res.body);
  //     return data.map((e) => Cafe.fromJson(e)).toList();
  //   }
  //   throw Exception('Gagal memuat data cafe');
  // }
  // ---------------------------------------------------------------------

  /// Mengambil cafe berdasarkan kategori yang dipilih pengguna.
  static Future<List<Cafe>> ambilBerdasarKategori(Kategori kategori) async {
    final semua = await ambilSemuaCafe();
    return semua.where(kategori.filter).toList();
  }

  /// Mengambil cafe berdasarkan kampus terdekat.
  static Future<List<Cafe>> ambilBerdasarKampus(String kampus) async {
    final semua = await ambilSemuaCafe();
    if (kampus == 'Semua') return semua;
    return semua.where((c) => c.kampusTerdekat.contains(kampus)).toList();
  }

  /// Mengambil cafe dengan skor nugas tertinggi untuk "Paling Cocok Nugas".
  static Future<List<Cafe>> ambilFavorit({int jumlah = 5}) async {
    final semua = List<Cafe>.from(await ambilSemuaCafe());
    semua.sort((a, b) => b.skorNugas.compareTo(a.skorNugas));
    return semua.take(jumlah).toList();
  }

  /// Mencari cafe berdasarkan nama atau area.
  static Future<List<Cafe>> cari(String kataKunci) async {
    final semua = await ambilSemuaCafe();
    final kunci = kataKunci.toLowerCase();
    return semua
        .where((c) =>
            c.nama.toLowerCase().contains(kunci) ||
            c.area.toLowerCase().contains(kunci))
        .toList();
  }
}
