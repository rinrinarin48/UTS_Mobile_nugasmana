import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../services/favorite_service.dart';
import '../theme/app_theme.dart';

/// Tombol favorit berbentuk hati.
///
/// Menggunakan ValueListenableBuilder agar ikon langsung berubah di seluruh
/// halaman begitu status favorit diperbarui, tanpa perlu memuat ulang halaman.
class TombolFavorit extends StatelessWidget {
  final Cafe cafe;

  /// Gaya bulat dengan latar gelap, dipakai di atas foto halaman detail.
  final bool gayaBulat;

  const TombolFavorit({
    super.key,
    required this.cafe,
    this.gayaBulat = false,
  });

  Future<void> _ubah(BuildContext context) async {
    final jadiFavorit = await FavoriteService.ubah(cafe.id);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Text(
            jadiFavorit
                ? '${cafe.nama} ditambahkan ke Favorit'
                : '${cafe.nama} dihapus dari Favorit',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: FavoriteService.favorit,
      builder: (context, daftar, _) {
        final aktif = daftar.contains(cafe.id);
        final ikon = aktif ? Icons.favorite : Icons.favorite_border;

        if (gayaBulat) {
          return GestureDetector(
            onTap: () => _ubah(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.35),
                shape: BoxShape.circle,
              ),
              child: Icon(
                ikon,
                size: 20,
                color: aktif ? Colors.redAccent : Colors.white,
              ),
            ),
          );
        }

        return IconButton(
          onPressed: () => _ubah(context),
          iconSize: 20,
          visualDensity: VisualDensity.compact,
          icon: Icon(
            ikon,
            color: aktif ? Colors.redAccent : AppColors.teksSekunder,
          ),
        );
      },
    );
  }
}
