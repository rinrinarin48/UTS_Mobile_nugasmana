import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/cafe.dart';

class CafeService {
  static const String _pathAsset = 'assets/data/cafes.json';

  /// URL API yang akan dipakai pada tahap berikutnya.
  /// Contoh: file JSON yang di-host di GitHub (raw) atau MockAPI.io.
  // static const String _urlApi =
  //     'https://raw.githubusercontent.com/username/nugasmana/main/data/cafes.json';

  
  static List<Cafe>? _cache;

  
  static Future<List<Cafe>> ambilSemuaCafe() async {
    if (_cache != null) return _cache!;

    final String isiFile = await rootBundle.loadString(_pathAsset);
    final List<dynamic> data = jsonDecode(isiFile) as List<dynamic>;
    _cache = data
        .map((item) => Cafe.fromJson(item as Map<String, dynamic>))
        .toList();
    return _cache!;
  }


  static Future<List<Cafe>> ambilBerdasarKategori(Kategori kategori) async {
    final semua = await ambilSemuaCafe();
    return semua.where(kategori.filter).toList();
  }

  static Future<List<Cafe>> ambilBerdasarKampus(String kampus) async {
    final semua = await ambilSemuaCafe();
    if (kampus == 'Semua') return semua;
    return semua.where((c) => c.kampusTerdekat.contains(kampus)).toList();
  }


  static Future<List<Cafe>> ambilFavorit({int jumlah = 5}) async {
    final semua = List<Cafe>.from(await ambilSemuaCafe());
    semua.sort((a, b) => b.skorNugas.compareTo(a.skorNugas));
    return semua.take(jumlah).toList();
  }

  
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
