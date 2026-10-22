import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Badge fasilitas berbentuk pil, contoh: WiFi, Colokan, AC.
class BadgeFasilitas extends StatelessWidget {
  final String label;
  final bool sorot;

  const BadgeFasilitas({super.key, required this.label, this.sorot = false});

  /// Memilih ikon yang sesuai dengan nama fasilitas.
  static IconData ikonUntuk(String nama) {
    switch (nama.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'colokan':
        return Icons.power;
      case 'ac':
        return Icons.ac_unit;
      case 'mushola':
        return Icons.mosque;
      case 'parkir luas':
        return Icons.local_parking;
      case 'toilet':
        return Icons.wc;
      case 'smoking area':
        return Icons.smoking_rooms;
      case 'outdoor':
        return Icons.park;
      default:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final warna = sorot ? AppColors.hijau : AppColors.latte;
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: warna.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikonUntuk(label), size: 14, color: warna),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: warna,
            ),
          ),
        ],
      ),
    );
  }
}

/// Lencana skor kecocokan untuk nugas.
///
/// Menggantikan rating bintang, karena rating tidak dapat diverifikasi.
/// Skor dihitung dari kelengkapan fasilitas dan jam buka.
class BadgeSkorNugas extends StatelessWidget {
  final int skor;
  final bool ringkas;

  const BadgeSkorNugas({super.key, required this.skor, this.ringkas = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.bolt_rounded, size: 16, color: AppColors.jeruk),
        const SizedBox(width: 2),
        Text(
          '$skor/10',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.teksUtama,
          ),
        ),
        if (!ringkas) ...[
          const SizedBox(width: 4),
          const Text(
            'nugas',
            style: TextStyle(fontSize: 11, color: AppColors.teksSekunder),
          ),
        ],
      ],
    );
  }
}

/// Gambar cafe dengan penanganan error.
/// Bila gambar dari internet gagal dimuat, ditampilkan placeholder berikon kopi
/// sehingga aplikasi tetap dapat dijalankan tanpa koneksi internet.
class GambarCafe extends StatelessWidget {
  final String url;
  final double? lebar;
  final double? tinggi;
  final BorderRadius? radius;

  const GambarCafe({
    super.key,
    required this.url,
    this.lebar,
    this.tinggi,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius ?? BorderRadius.circular(12),
      child: Image.network(
        url,
        width: lebar,
        height: tinggi,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return _placeholder(memuat: true);
        },
      ),
    );
  }

  Widget _placeholder({bool memuat = false}) {
    return Container(
      width: lebar,
      height: tinggi,
      color: AppColors.latte.withOpacity(0.18),
      alignment: Alignment.center,
      child: memuat
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.latte,
              ),
            )
          : Icon(
              Icons.local_cafe_rounded,
              color: AppColors.latte.withOpacity(0.7),
              size: (tinggi ?? 60) * 0.35,
            ),
    );
  }
}

/// Judul bagian dengan tautan opsional di sebelah kanan.
class JudulBagian extends StatelessWidget {
  final String judul;
  final VoidCallback? onLihatSemua;

  const JudulBagian({super.key, required this.judul, this.onLihatSemua});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(judul, style: Theme.of(context).textTheme.titleMedium),
          if (onLihatSemua != null)
            GestureDetector(
              onTap: onLihatSemua,
              child: const Text(
                'Lihat semua',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.jeruk,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
