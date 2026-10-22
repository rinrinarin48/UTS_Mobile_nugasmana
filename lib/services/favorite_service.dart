import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pengelola daftar cafe favorit.
///
/// Sebelumnya tombol favorit hanya menampilkan SnackBar tanpa menyimpan
/// apa pun, sehingga cafe tidak pernah muncul di tab Favorit. Kelas ini
/// menyimpan id cafe favorit secara permanen menggunakan SharedPreferences
/// dan memberitahu seluruh halaman setiap kali daftarnya berubah.
class FavoriteService {
  static const String _kunci = 'cafe_favorit';

  /// Daftar id cafe favorit yang dapat dipantau oleh widget.
  /// Setiap perubahan otomatis memperbarui tampilan yang mendengarkannya.
  static final ValueNotifier<Set<String>> favorit =
      ValueNotifier<Set<String>>({});

  /// Memuat data favorit dari penyimpanan perangkat.
  /// Dipanggil sekali saat aplikasi mulai berjalan.
  static Future<void> muat() async {
    final prefs = await SharedPreferences.getInstance();
    final daftar = prefs.getStringList(_kunci) ?? [];
    favorit.value = daftar.toSet();
  }

  /// Menyimpan daftar favorit ke penyimpanan perangkat.
  static Future<void> _simpan() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kunci, favorit.value.toList());
  }

  /// Memeriksa apakah sebuah cafe sudah ditandai favorit.
  static bool apakahFavorit(String idCafe) => favorit.value.contains(idCafe);

  /// Menambah atau menghapus cafe dari daftar favorit.
  /// Mengembalikan true bila cafe menjadi favorit, false bila dihapus.
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

  /// Mengosongkan seluruh daftar favorit.
  static Future<void> hapusSemua() async {
    favorit.value = {};
    await _simpan();
  }
}
