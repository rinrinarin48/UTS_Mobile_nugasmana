import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../theme/app_theme.dart';
import '../services/maps_service.dart';
import '../widgets/common_widgets.dart';
import '../widgets/favorite_button.dart';


class CafeDetailPage extends StatelessWidget {
  final Cafe cafe;

  const CafeDetailPage({super.key, required this.cafe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krim,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                GambarCafe(
                  url: cafe.gambar,
                  lebar: double.infinity,
                  tinggi: 280,
                  radius: BorderRadius.zero,
                ),
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                    decoration: const BoxDecoration(
                      color: AppColors.putih,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cafe.nama,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.place_outlined,
                                size: 15, color: AppColors.teksSekunder),
                            const SizedBox(width: 4),
                            Text(
                              cafe.area,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.teksSekunder,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            BadgeSkorNugas(skor: cafe.skorNugas),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color:
                                    AppColors.hijau.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                cafe.buka24Jam
                                    ? 'Buka 24 jam'
                                    : cafe.jamBuka,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.hijau,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _buildSkorNugas(),
                        const SizedBox(height: 22),
                        _buildInfo(Icons.place_outlined, 'Alamat', cafe.alamat),
                        _buildInfo(Icons.access_time_rounded, 'Jam Buka',
                            cafe.jamBuka),
                        _buildInfo(Icons.payments_outlined, 'Kisaran Harga',
                            cafe.kisaranHargaPanjang),
                        _buildInfo(Icons.school_outlined, 'Kampus Terdekat',
                            cafe.kampusTerdekat.join(', ')),
                        const SizedBox(height: 18),
                        _buildJudul(context, 'Fasilitas'),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: cafe.fasilitas
                              .map((f) => BadgeFasilitas(label: f))
                              .toList(),
                        ),
                        const SizedBox(height: 22),
                        _buildJudul(context, 'Tentang Tempat Ini'),
                        const SizedBox(height: 8),
                        Text(
                          cafe.deskripsi,
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.6,
                            color: AppColors.teksSekunder,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _buildJudul(context, 'Galeri'),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (_, i) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: GambarCafe(
                                url: cafe.gambar,
                                lebar: 120,
                                tinggi: 90,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 22),
                        _buildSumber(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildTombolAtas(context),
          _buildTombolBawah(context),
        ],
      ),
    );
  }

  
  Widget _buildSkorNugas() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.jeruk.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(
            '${cafe.skorNugas}',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppColors.jeruk,
            ),
          ),
          const Text(
            '/10',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.jeruk,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Skor Nugas',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.teksUtama,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  cafe.keteranganSkor,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.teksSekunder,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(IconData ikon, String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.krim,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(ikon, size: 17, color: AppColors.kopi),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.teksSekunder,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  nilai,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.teksUtama,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildSumber(BuildContext context) {
    return GestureDetector(
      onTap: () => MapsService.bukaSumber(context, cafe),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.krim,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.link_rounded,
                size: 16, color: AppColors.teksSekunder),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Sumber informasi cafe ini',
                style: TextStyle(fontSize: 12, color: AppColors.teksSekunder),
              ),
            ),
            const Icon(Icons.open_in_new_rounded,
                size: 14, color: AppColors.jeruk),
          ],
        ),
      ),
    );
  }

  Widget _buildJudul(BuildContext context, String teks) {
    return Text(teks, style: Theme.of(context).textTheme.titleMedium);
  }

  
  Widget _buildTombolAtas(BuildContext context) {
    return Positioned(
      top: 44,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _tombolBulat(
            ikon: Icons.arrow_back,
            onTap: () => Navigator.pop(context),
          ),
          TombolFavorit(cafe: cafe, gayaBulat: true),
        ],
      ),
    );
  }

  Widget _tombolBulat({required IconData ikon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(ikon, color: Colors.white, size: 20),
      ),
    );
  }

  
  Widget _buildTombolBawah(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: BoxDecoration(
          color: AppColors.putih,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              offset: const Offset(0, -4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Row(
          children: [
            // Tombol sekunder: melihat posisi cafe tanpa memulai rute.
            SizedBox(
              width: 48,
              height: 48,
              child: OutlinedButton(
                onPressed: () => MapsService.bukaLokasi(context, cafe),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: AppColors.kopi,
                  side: const BorderSide(color: AppColors.kopi),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Icon(Icons.place_outlined, size: 20),
              ),
            ),
            const SizedBox(width: 10),
            // Tombol utama: langsung menampilkan rute menuju cafe.
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => MapsService.bukaRute(context, cafe),
                icon: const Icon(Icons.directions_rounded, size: 18),
                label: const Text('Lihat Rute ke Sini'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
