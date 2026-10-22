import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../models/kampus.dart';
import '../services/auth_service.dart';
import '../services/cafe_service.dart';
import '../theme/app_theme.dart';
import '../widgets/cafe_card.dart';
import '../widgets/common_widgets.dart';
import 'cafe_list_page.dart';
import 'cafe_detail_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _kampusTerpilih = 'Semua';

  
  final List<String> _daftarKampus = Kampus.kodeUntukFilter;

  
  void _bukaDaftar({Kategori? kategori, String? judul, String? kampus}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CafeListPage(
          kategori: kategori,
          judul: judul ?? kategori?.nama ?? 'Semua Cafe',
          kampus: kampus,
        ),
      ),
    );
  }

  
  void _bukaDetail(Cafe cafe) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CafeDetailPage(cafe: cafe)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 22),
          _buildKategori(),
          const SizedBox(height: 24),
          JudulBagian(
            judul: 'Paling Cocok Nugas',
            onLihatSemua: () => _bukaDaftar(judul: 'Semua Cafe'),
          ),
          _buildCarouselFavorit(),
          const SizedBox(height: 24),
          const JudulBagian(judul: 'Dekat Kampus'),
          _buildFilterKampus(),
          const SizedBox(height: 14),
          _buildDaftarKampus(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  
  Widget _buildInfoKampus() {
    final kampus = Kampus.cariKode(_kampusTerpilih);
    if (kampus == null) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.kopi.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  kampus.namaLengkap,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.kopi,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: kampus.negeri
                      ? AppColors.hijau.withOpacity(0.15)
                      : AppColors.jeruk.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  kampus.negeri ? 'Negeri' : 'Swasta',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: kampus.negeri ? AppColors.hijau : AppColors.jeruk,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${kampus.alamat} · ${kampus.keterangan}',
            style: const TextStyle(
              fontSize: 11,
              height: 1.4,
              color: AppColors.teksSekunder,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pesanError(Object? error) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gagal memuat data cafe',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Periksa bagian assets pada pubspec.yaml, '
              'lalu jalankan flutter pub get dan restart aplikasi.',
              style: TextStyle(fontSize: 12, color: AppColors.teksSekunder),
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              style: const TextStyle(fontSize: 11, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.kopi,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sapaan menyesuaikan nama pengguna yang sedang masuk.
          ValueListenableBuilder<bool>(
            valueListenable: AuthService.sudahMasuk,
            builder: (context, masuk, _) => Text(
              masuk ? 'Halo, ${AuthService.namaPengguna}!' : 'Halo, Mahasiswa!',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Mau nugas di mana hari ini?',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.70),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.putih,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, size: 20, color: AppColors.teksSekunder),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari nama cafe atau area...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: AppColors.teksSekunder,
                      ),
                      border: InputBorder.none,
                      isCollapsed: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKategori() {
    return SizedBox(
      height: 92,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: Kategori.semua.length,
        itemBuilder: (context, i) {
          final kategori = Kategori.semua[i];
          return GestureDetector(
            onTap: () => _bukaDaftar(kategori: kategori),
            child: Container(
              width: 76,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppColors.putih,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppTheme.bayanganKartu,
                    ),
                    child: Icon(
                      _ikonKategori(kategori.ikon),
                      color: AppColors.jeruk,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    kategori.nama,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 10,
                      height: 1.2,
                      color: AppColors.teksSekunder,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _ikonKategori(String nama) {
    switch (nama) {
      case 'wifi':
        return Icons.wifi_rounded;
      case 'power':
        return Icons.power_rounded;
      case 'clock':
        return Icons.access_time_rounded;
      case 'wallet':
        return Icons.account_balance_wallet_rounded;
      case 'quiet':
        return Icons.volume_off_rounded;
      case 'space':
        return Icons.weekend_rounded;
      default:
        return Icons.local_cafe_rounded;
    }
  }
  Widget _buildCarouselFavorit() {
    return FutureBuilder<List<Cafe>>(
      future: CafeService.ambilFavorit(jumlah: 5),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _pesanError(snapshot.error);
        }
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 244,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final daftar = snapshot.data!;
        return SizedBox(
          height: 244,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: daftar.length,
            itemBuilder: (context, i) => KartuCafeBesar(
              cafe: daftar[i],
              onTap: () => _bukaDetail(daftar[i]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterKampus() {
    return SizedBox(
      height: 34,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _daftarKampus.length,
        itemBuilder: (context, i) {
          final kampus = _daftarKampus[i];
          final aktif = kampus == _kampusTerpilih;
          return GestureDetector(
            onTap: () => setState(() => _kampusTerpilih = kampus),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: aktif ? AppColors.jeruk : AppColors.putih,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: aktif ? AppColors.jeruk : AppColors.krim,
                ),
              ),
              child: Text(
                kampus,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: aktif ? Colors.white : AppColors.teksSekunder,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDaftarKampus() {
    return FutureBuilder<List<Cafe>>(
      future: CafeService.ambilBerdasarKampus(_kampusTerpilih),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _pesanError(snapshot.error);
        }
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(30),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final daftar = snapshot.data!.take(4).toList();
        if (daftar.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(30),
            child: Center(
              child: Text(
                'Belum ada cafe untuk kampus ini.',
                style: TextStyle(color: AppColors.teksSekunder),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _buildInfoKampus(),
              ...daftar.map((c) => KartuCafeRingkas(
                    cafe: c,
                    onTap: () => _bukaDetail(c),
                  )),
            ],
          ),
        );
      },
    );
  }
}
