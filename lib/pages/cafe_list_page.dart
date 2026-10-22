import 'package:flutter/material.dart';
import '../models/cafe.dart';
import '../services/cafe_service.dart';
import '../theme/app_theme.dart';
import '../widgets/cafe_card.dart';
import 'cafe_detail_page.dart';

/// HALAMAN 2 - DAFTAR CAFE
/// Menampilkan daftar cafe hasil penyaringan berdasarkan kategori atau kampus,
/// lengkap dengan pilihan pengurutan.
class CafeListPage extends StatefulWidget {
  final Kategori? kategori;
  final String judul;
  final String? kampus;

  const CafeListPage({
    super.key,
    this.kategori,
    required this.judul,
    this.kampus,
  });

  @override
  State<CafeListPage> createState() => _CafeListPageState();
}

class _CafeListPageState extends State<CafeListPage> {
  String _urutan = 'Paling Cocok Nugas';
  final List<String> _pilihanUrutan = [
    'Paling Cocok Nugas',
    'Termurah',
    'Buka Paling Lama',
  ];

  /// Mengambil data sesuai kategori / kampus, lalu mengurutkannya.
  Future<List<Cafe>> _ambilData() async {
    List<Cafe> hasil;
    if (widget.kategori != null) {
      hasil = await CafeService.ambilBerdasarKategori(widget.kategori!);
    } else if (widget.kampus != null) {
      hasil = await CafeService.ambilBerdasarKampus(widget.kampus!);
    } else {
      hasil = List<Cafe>.from(await CafeService.ambilSemuaCafe());
    }

    hasil = List<Cafe>.from(hasil);
    switch (_urutan) {
      case 'Termurah':
        hasil.sort((a, b) => a.hargaMin.compareTo(b.hargaMin));
        break;
      case 'Buka Paling Lama':
        hasil.sort((a, b) {
          if (a.buka24Jam != b.buka24Jam) return a.buka24Jam ? -1 : 1;
          return b.jamBuka.compareTo(a.jamBuka);
        });
        break;
      default:
        hasil.sort((a, b) => b.skorNugas.compareTo(a.skorNugas));
    }
    return hasil;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krim,
      appBar: AppBar(
        backgroundColor: AppColors.kopi,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.judul,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Filter lanjutan akan ditambahkan')),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 14),
          _buildChipUrutan(),
          const SizedBox(height: 14),
          Expanded(
            child: FutureBuilder<List<Cafe>>(
              future: _ambilData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Gagal memuat data cafe'));
                }
                final daftar = snapshot.data ?? [];
                if (daftar.isEmpty) {
                  return const Center(
                    child: Text(
                      'Tidak ada cafe yang cocok dengan kategori ini.',
                      style: TextStyle(color: AppColors.teksSekunder),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: daftar.length + 1,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          '${daftar.length} cafe ditemukan',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.teksSekunder,
                          ),
                        ),
                      );
                    }
                    final cafe = daftar[i - 1];
                    return KartuCafeDaftar(
                      cafe: cafe,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CafeDetailPage(cafe: cafe),
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

  Widget _buildChipUrutan() {
    return SizedBox(
      height: 34,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _pilihanUrutan.length,
        itemBuilder: (context, i) {
          final pilihan = _pilihanUrutan[i];
          final aktif = pilihan == _urutan;
          return GestureDetector(
            onTap: () => setState(() => _urutan = pilihan),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: aktif ? AppColors.jeruk : AppColors.putih,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                pilihan,
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
}
