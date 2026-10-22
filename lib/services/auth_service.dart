import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pengelola sesi login pengguna.
///
/// Pada tahap ini proses login masih disimulasikan di dalam aplikasi
/// (belum terhubung ke server). Data akun disimpan di perangkat sehingga
/// pengguna tidak perlu login ulang setiap membuka aplikasi.
///
/// Pada tahap pengembangan berikutnya, metode [login] dan [daftar] cukup
/// diganti dengan permintaan HTTP ke endpoint autentikasi.
class AuthService {
  static const String _kunciNama = 'pengguna_nama';
  static const String _kunciEmail = 'pengguna_email';
  static const String _kunciSandi = 'pengguna_sandi';
  static const String _kunciMasuk = 'pengguna_masuk';

  /// Akun contoh agar aplikasi dapat langsung diuji tanpa mendaftar.
  static const String emailDemo = 'mahasiswa@malang.ac.id';
  static const String sandiDemo = '123456';

  /// Status login yang dapat dipantau oleh widget.
  static final ValueNotifier<bool> sudahMasuk = ValueNotifier<bool>(false);

  /// Nama dan email pengguna yang sedang masuk.
  static String namaPengguna = 'Mahasiswa';
  static String emailPengguna = '';

  /// Memuat status login dari penyimpanan perangkat.
  static Future<void> muat() async {
    final prefs = await SharedPreferences.getInstance();
    sudahMasuk.value = prefs.getBool(_kunciMasuk) ?? false;
    namaPengguna = prefs.getString(_kunciNama) ?? 'Mahasiswa';
    emailPengguna = prefs.getString(_kunciEmail) ?? '';
  }

  /// Memproses login. Mengembalikan pesan kesalahan bila gagal,
  /// atau null bila berhasil.
  static Future<String?> login(String email, String sandi) async {
    // Jeda singkat untuk meniru proses permintaan ke server.
    await Future.delayed(const Duration(milliseconds: 600));

    final prefs = await SharedPreferences.getInstance();
    final emailTersimpan = prefs.getString(_kunciEmail);
    final sandiTersimpan = prefs.getString(_kunciSandi);

    final cocokDemo = email == emailDemo && sandi == sandiDemo;
    final cocokTersimpan =
        emailTersimpan != null && email == emailTersimpan && sandi == sandiTersimpan;

    if (!cocokDemo && !cocokTersimpan) {
      return 'Email atau kata sandi salah';
    }

    namaPengguna = prefs.getString(_kunciNama) ??
        (cocokDemo ? 'Mahasiswa Malang' : email.split('@').first);
    emailPengguna = email;

    await prefs.setBool(_kunciMasuk, true);
    await prefs.setString(_kunciEmail, email);
    await prefs.setString(_kunciNama, namaPengguna);
    sudahMasuk.value = true;
    return null;
  }

  /// Mendaftarkan akun baru pada perangkat.
  static Future<String?> daftar(
    String nama,
    String email,
    String sandi,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (nama.trim().isEmpty) return 'Nama tidak boleh kosong';
    if (!email.contains('@')) return 'Format email tidak benar';
    if (sandi.length < 6) return 'Kata sandi minimal 6 karakter';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kunciNama, nama.trim());
    await prefs.setString(_kunciEmail, email.trim());
    await prefs.setString(_kunciSandi, sandi);
    await prefs.setBool(_kunciMasuk, true);

    namaPengguna = nama.trim();
    emailPengguna = email.trim();
    sudahMasuk.value = true;
    return null;
  }

  /// Keluar dari akun. Daftar favorit tetap tersimpan.
  static Future<void> keluar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kunciMasuk, false);
    sudahMasuk.value = false;
  }
}
