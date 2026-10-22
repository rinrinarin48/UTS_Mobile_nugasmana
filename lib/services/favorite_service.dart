import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _kunci = 'cafe_favorit';


  static final ValueNotifier<Set<String>> favorit =
      ValueNotifier<Set<String>>({});

  static Future<void> muat() async {
    final prefs = await SharedPreferences.getInstance();
    final daftar = prefs.getStringList(_kunci) ?? [];
    favorit.value = daftar.toSet();
  }

  static Future<void> _simpan() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kunci, favorit.value.toList());
  }

  static bool apakahFavorit(String idCafe) => favorit.value.contains(idCafe);

 
  static Future<bool> ubah(String idCafe) async {
    // Set baru dibuat agar ValueNotifier mendeteksi perubahan.
    final baru = Set<String>.from(favorit.value);
    final menjadiFavorit = !baru.contains(idCafe);

    if (menjadiFavorit) {
      baru.add(idCafe);
    } else {
      baru.remove(idCafe);
    }

    favorit.value = baru;
    await _simpan();
    return menjadiFavorit;
  }

  static Future<void> hapusSemua() async {
    favorit.value = {};
    await _simpan();
  }
}
