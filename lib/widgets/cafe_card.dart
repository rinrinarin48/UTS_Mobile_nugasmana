import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../theme/app_theme.dart';
import 'common_widgets.dart';
import 'favorite_button.dart';

class KartuCafeBesar extends StatelessWidget {
  final Cafe cafe;
  final VoidCallback onTap;

  const KartuCafeBesar({super.key, required this.cafe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: AppColors.putih,
          borderRadius: AppTheme.radiusKartu,
          boxShadow: AppTheme.bayanganKartu,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                GambarCafe(
                  url: cafe.gambar,
                  lebar: double.infinity,
                  tinggi: 130,
                  radius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: TombolFavorit(cafe: cafe, gayaBulat: true),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cafe.nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.teksUtama,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.place_outlined,
                          size: 13, color: AppColors.teksSekunder),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          cafe.area,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.teksSekunder,
                          ),
                        ),
                      ),
                      BadgeSkorNugas(skor: cafe.skorNugas, ringkas: true),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cafe.kisaranHarga,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.jeruk,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KartuCafeRingkas extends StatelessWidget {
  final Cafe cafe;
  final VoidCallback onTap;

  const KartuCafeRingkas({super.key, required this.cafe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.putih,
          borderRadius: AppTheme.radiusKartu,
          boxShadow: AppTheme.bayanganKartu,
        ),
        child: Row(
          children: [
            GambarCafe(url: cafe.gambar, lebar: 72, tinggi: 72),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cafe.nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.teksUtama,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    cafe.area,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 6,
                    children: cafe.fasilitas
                        .take(2)
                        .map((f) => BadgeFasilitas(label: f))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 28,
                  child: TombolFavorit(cafe: cafe),
                ),
                BadgeSkorNugas(skor: cafe.skorNugas, ringkas: true),
                const SizedBox(height: 6),
                Text(
                  cafe.kisaranHarga,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.jeruk,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class KartuCafeDaftar extends StatelessWidget {
  final Cafe cafe;
  final VoidCallback onTap;

  const KartuCafeDaftar({super.key, required this.cafe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.putih,
        borderRadius: AppTheme.radiusKartu,
        boxShadow: AppTheme.bayanganKartu,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GambarCafe(url: cafe.gambar, lebar: 96, tinggi: 96),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cafe.nama,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined,
                            size: 13, color: AppColors.teksSekunder),
                        const SizedBox(width: 3),
                        Text(
                          cafe.area,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.teksSekunder,
                          ),
                        ),
                        const SizedBox(width: 10),
                        BadgeSkorNugas(skor: cafe.skorNugas),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: cafe.fasilitas
                          .take(3)
                          .map((f) => BadgeFasilitas(label: f))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    cafe.kisaranHarga,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.jeruk,
                    ),
                  ),
                  TombolFavorit(cafe: cafe),
                ],
              ),
              OutlinedButton(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.kopi,
                  side: const BorderSide(color: AppColors.kopi),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  minimumSize: const Size(0, 34),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Lihat Detail',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
