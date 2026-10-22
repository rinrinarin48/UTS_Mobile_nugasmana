import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/cafe.dart';


class MapsService {
  
  static String _kueri(Cafe cafe) =>
      Uri.encodeComponent('${cafe.nama}, ${cafe.alamat}');

  
  static Future<void> bukaRute(
    BuildContext context,
    Cafe cafe, {
    String modeJalan = 'driving',
  }) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${_kueri(cafe)}'
      '&travelmode=$modeJalan',
    );

    await _jalankan(context, url);
  }

  /// Membuka halaman lokasi cafe tanpa rute.
  /// Dipakai bila pengguna hanya ingin melihat posisi cafe di peta.
  static Future<void> bukaLokasi(BuildContext context, Cafe cafe) async {
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${_kueri(cafe)}',
    );

    await _jalankan(context, url);
  }

  /// Membuka artikel sumber data cafe.
  static Future<void> bukaSumber(BuildContext context, Cafe cafe) async {
    await _jalankan(context, Uri.parse(cafe.sumber));
  }

  /// Menjalankan tautan dan menampilkan pesan bila gagal.
  static Future<void> _jalankan(BuildContext context, Uri url) async {
    try {
      final berhasil = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!berhasil) throw Exception('Tautan tidak dapat dibuka');
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal membuka tautan di perangkat ini'),
        ),
      );
    }
  }
}
