import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../models/kampus.dart';
import '../services/auth_service.dart';
import '../services/cafe_service.dart';
import '../services/favorite_service.dart';
import '../theme/app_theme.dart';
import '../widgets/cafe_card.dart';
import 'home_page.dart';
import 'cafe_list_page.dart';
import 'cafe_detail_page.dart';
import 'login_page.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _indeks = 0;

  final List<Widget> _halaman = const [
    HomePage(),
    _JelajahPage(),
    _FavoritPage(),
    _ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krim,
      body: IndexedStack(index: _indeks, children: _halaman),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indeks,
        onTap: (i) => setState(() => _indeks = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.putih,
        selectedItemColor: AppColors.jeruk,
        unselectedItemColor: AppColors.teksSekunder,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            label: 'Jelajah',
          ),
          // Ikon favorit menampilkan jumlah cafe yang tersimpan.
          BottomNavigationBarItem(
            icon: ValueListenableBuilder<Set<String>>(
              valueListenable: FavoriteService.favorit,
              builder: (context, daftar, _) {
                if (daftar.isEmpty) {
                  return const Icon(Icons.favorite_rounded);
                }
                return Badge(
                  label: Text('${daftar.length}'),
                  backgroundColor: AppColors.jeruk,
                  child: const Icon(Icons.favorite_rounded),
                );
              },
            ),
            label: 'Favorit',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}


class _JelajahPage extends StatelessWidget {
  const _JelajahPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        children: [
          const Text(
            'Jelajah',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.teksUtama,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Berdasarkan Fasilitas',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.teksUtama,
            ),
          ),
          const SizedBox(height: 10),
          ...Kategori.semua.map(
            (kategori) => _buildBaris(
              context,
              ikon: Icons.local_cafe_rounded,
              judul: kategori.nama,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CafeListPage(
                    kategori: kategori,
                    judul: kategori.nama,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Berdasarkan Kampus',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.teksUtama,
            ),
          ),
          const SizedBox(height: 10),
          ...Kampus.semua.map(
            (kampus) => _buildBaris(
              context,
              ikon: kampus.negeri
                  ? Icons.account_balance_rounded
                  : Icons.school_rounded,
              judul: kampus.kode,
              subjudul: '${kampus.namaLengkap} - ${kampus.alamat}',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CafeListPage(
                    kampus: kampus.kode,
                    judul: 'Dekat ${kampus.kode}',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaris(
    BuildContext context, {
    required IconData ikon,
    required String judul,
    String? subjudul,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.putih,
        borderRadius: AppTheme.radiusKartu,
        boxShadow: AppTheme.bayanganKartu,
      ),
      child: ListTile(
        leading: Icon(ikon, color: AppColors.jeruk),
        title: Text(
          judul,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: subjudul == null
            ? null
            : Text(
                subjudul,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 11, color: AppColors.teksSekunder),
              ),
        trailing:
            const Icon(Icons.chevron_right, color: AppColors.teksSekunder),
        onTap: onTap,
      ),
    );
  }
}


class _FavoritPage extends StatelessWidget {
  const _FavoritPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Favorit Saya',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.teksUtama,
                  ),
                ),
                ValueListenableBuilder<Set<String>>(
                  valueListenable: FavoriteService.favorit,
                  builder: (context, daftar, _) {
                    if (daftar.isEmpty) return const SizedBox.shrink();
                    return TextButton(
                      onPressed: () => FavoriteService.hapusSemua(),
                      child: const Text(
                        'Hapus semua',
                        style: TextStyle(fontSize: 12, color: AppColors.jeruk),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<Set<String>>(
              valueListenable: FavoriteService.favorit,
              builder: (context, idFavorit, _) {
                if (idFavorit.isEmpty) return const _FavoritKosong();

                return FutureBuilder<List<Cafe>>(
                  future: CafeService.ambilSemuaCafe(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final daftar = snapshot.data!
                        .where((c) => idFavorit.contains(c.id))
                        .toList();

                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: daftar.length,
                      itemBuilder: (context, i) => KartuCafeRingkas(
                        cafe: daftar[i],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CafeDetailPage(cafe: daftar[i]),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoritKosong extends StatelessWidget {
  const _FavoritKosong();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border_rounded,
              size: 56,
              color: AppColors.latte.withOpacity(0.5),
            ),
            const SizedBox(height: 14),
            const Text(
              'Belum ada cafe favorit',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.teksUtama,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tekan ikon hati pada kartu cafe atau di\nhalaman detail untuk menyimpannya di sini.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: AppColors.teksSekunder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilPage extends StatelessWidget {
  const _ProfilPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder<bool>(
        valueListenable: AuthService.sudahMasuk,
        builder: (context, masuk, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: const BoxDecoration(
                    color: AppColors.kopi,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    masuk ? Icons.person : Icons.person_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                masuk ? AuthService.namaPengguna : 'Belum Masuk',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.teksUtama,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                masuk
                    ? AuthService.emailPengguna
                    : 'Masuk untuk menyimpan favoritmu',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.teksSekunder,
                ),
              ),
              const SizedBox(height: 24),

              if (masuk)
                ValueListenableBuilder<Set<String>>(
                  valueListenable: FavoriteService.favorit,
                  builder: (context, daftar, _) => _buildKartuInfo(
                    'Cafe Favorit',
                    '${daftar.length} tempat tersimpan',
                    Icons.favorite_rounded,
                  ),
                ),

              _buildKartuInfo(
                'Cakupan Wilayah',
                'Kota Malang, ${Kampus.semua.length} perguruan tinggi',
                Icons.place_rounded,
              ),
              _buildKartuInfo(
                'Tentang Aplikasi',
                'UTS Mobile Programming, Semester Ganjil 2025/2026',
                Icons.info_outline_rounded,
              ),

              const SizedBox(height: 10),
              if (masuk)
                OutlinedButton.icon(
                  onPressed: () => AuthService.keluar(),
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  label: const Text('Keluar dari Akun'),
                )
              else
                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  ),
                  icon: const Icon(Icons.login_rounded, size: 18),
                  label: const Text('Masuk atau Daftar'),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildKartuInfo(String judul, String nilai, IconData ikon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.putih,
        borderRadius: AppTheme.radiusKartu,
        boxShadow: AppTheme.bayanganKartu,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.krim,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(ikon, size: 18, color: AppColors.kopi),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  judul,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.teksUtama,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  nilai,
                  style: const TextStyle(
                    fontSize: 11,
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
}
