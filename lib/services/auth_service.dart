import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _kunciNama = 'pengguna_nama';
  static const String _kunciEmail = 'pengguna_email';
  static const String _kunciSandi = 'pengguna_sandi';
  static const String _kunciMasuk = 'pengguna_masuk';

  static const String emailDemo = 'mahasiswa@malang.ac.id';
  static const String sandiDemo = '123456';

  static final ValueNotifier<bool> sudahMasuk = ValueNotifier<bool>(false);

  static String namaPengguna = 'Mahasiswa';
  static String emailPengguna = '';


  static Future<void> muat() async {
    final prefs = await SharedPreferences.getInstance();
    sudahMasuk.value = prefs.getBool(_kunciMasuk) ?? false;
    namaPengguna = prefs.getString(_kunciNama) ?? 'Mahasiswa';
    emailPengguna = prefs.getString(_kunciEmail) ?? '';
  }

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

  static Future<void> keluar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kunciMasuk, false);
    sudahMasuk.value = false;
  }
}
