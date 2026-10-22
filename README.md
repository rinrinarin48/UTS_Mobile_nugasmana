# NugasMana

Aplikasi mobile rekomendasi tempat nugas (cafe dan coworking space) untuk mahasiswa di Kota Malang, dibangun menggunakan framework Flutter.

Dibuat untuk memenuhi Ujian Tengah Semester mata kuliah Mobile Programming, Semester Ganjil 2025/2026.

---

## Tema dan Tujuan Aplikasi

Malang dikenal sebagai kota pelajar dengan banyak perguruan tinggi seperti UB, UM, UMM, Polinema, dan UIN. Mahasiswa sering mencari tempat untuk mengerjakan tugas di luar kos atau kampus, namun informasi mengenai fasilitas sebuah cafe (kecepatan WiFi, ketersediaan colokan, jam buka, dan kisaran harga) biasanya tersebar dan tidak lengkap.

NugasMana bertujuan mengumpulkan informasi tersebut dalam satu aplikasi, sehingga mahasiswa dapat memilih tempat nugas sesuai kebutuhannya, misalnya tempat yang buka 24 jam saat mengejar deadline, atau tempat tenang untuk mengerjakan skripsi.

---

## Daftar Halaman dan Fungsinya

| No | Halaman | File | Fungsi |
|----|---------|------|--------|
| 1 | Beranda | `lib/pages/home_page.dart` | Menampilkan sapaan, kolom pencarian, enam ikon kategori, carousel cafe paling favorit, dan daftar cafe berdasarkan filter kampus terdekat. |
| 2 | Daftar Cafe | `lib/pages/cafe_list_page.dart` | Menampilkan hasil penyaringan cafe berdasarkan kategori yang dipilih, dilengkapi chip pengurutan (rating, harga, skor nugas) dan jumlah hasil. |
| 3 | Detail Cafe | `lib/pages/cafe_detail_page.dart` | Menampilkan informasi lengkap satu cafe: foto hero, rating, skor nugas, alamat, jam buka, kisaran harga, kecepatan WiFi, fasilitas, deskripsi, dan galeri. |
| 4 | Login dan Daftar | `lib/pages/login_page.dart` | Formulir masuk dan pendaftaran akun dengan validasi email serta kata sandi minimal enam karakter. |
| 5 | Jelajah, Favorit, Profil | `lib/pages/main_shell.dart` | Halaman pendukung yang diakses melalui BottomNavigationBar. |

### Akun Contoh

Email `mahasiswa@malang.ac.id` dengan kata sandi `123456`. Tersedia pula tombol "Isi otomatis" pada halaman login untuk mempercepat pengujian.

### Fitur Favorit

Daftar favorit dikelola oleh `lib/services/favorite_service.dart` menggunakan `ValueNotifier` dan `SharedPreferences`. Ikon hati tersedia pada kartu cafe maupun halaman detail. Perubahan status favorit langsung tercermin di seluruh halaman tanpa perlu memuat ulang, dan data tetap tersimpan meskipun aplikasi ditutup.

### Integrasi Google Maps

Tombol "Buka di Google Maps" pada halaman detail menggunakan package `url_launcher`. Pencarian dikirim berdasarkan nama dan alamat cafe, sehingga pada perangkat Android tautan akan langsung dibuka oleh aplikasi Google Maps apabila terpasang.

### Alur Navigasi

```
MainShell (BottomNavigationBar)
 ├── Beranda ──[Navigator.push]──> Daftar Cafe ──[Navigator.push]──> Detail Cafe
 ├── Jelajah ──[Navigator.push]──> Daftar Cafe ──[Navigator.push]──> Detail Cafe
 ├── Favorit ──[Navigator.push]──> Detail Cafe
 └── Profil
```

Aplikasi menggunakan dua mekanisme navigasi sekaligus:
- **BottomNavigationBar** untuk berpindah antar tab utama
- **Navigator.push** untuk masuk ke halaman daftar dan halaman detail

---

## Struktur Folder

```
nugasmana/
├── assets/
│   └── data/
│       └── cafes.json           # Data dummy 10 cafe di Kota Malang
├── lib/
│   ├── main.dart                # Titik masuk aplikasi
│   ├── models/
│   │   └── cafe.dart            # Model Cafe dan definisi Kategori
│   ├── services/
│   │   └── cafe_service.dart    # Lapisan penyedia data (JSON lokal / API)
│   ├── theme/
│   │   └── app_theme.dart       # Token warna, tipografi, dan tema global
│   ├── widgets/
│   │   ├── common_widgets.dart  # Badge fasilitas, rating, gambar, judul bagian
│   │   └── cafe_card.dart       # Tiga varian kartu cafe
│   └── pages/
│       ├── main_shell.dart      # Kerangka BottomNavigationBar
│       ├── home_page.dart       # Halaman 1
│       ├── cafe_list_page.dart  # Halaman 2
│       └── cafe_detail_page.dart# Halaman 3
├── pubspec.yaml
└── README.md
```

---

## Widget Flutter yang Digunakan

Scaffold, AppBar, BottomNavigationBar, IndexedStack, SingleChildScrollView, ListView.builder, Column, Row, Stack, Positioned, Container, Padding, Expanded, Wrap, Card (melalui Container berdekorasi), GestureDetector, FutureBuilder, ElevatedButton, OutlinedButton, TextField, ClipRRect, Transform, CircularProgressIndicator, SnackBar.

---

## Struktur Data

Setiap cafe disimpan dalam format berikut:

```json
{
  "id": "c001",
  "nama": "Kopi Sudut Dinoyo",
  "area": "Dinoyo",
  "kampusTerdekat": ["UB", "UIN"],
  "alamat": "Jl. MT Haryono No. 142, Dinoyo, Kota Malang",
  "jamBuka": "08.00 - 24.00",
  "buka24Jam": false,
  "hargaMin": 15000,
  "hargaMax": 35000,
  "fasilitas": ["WiFi", "Colokan", "AC", "Mushola", "Parkir Luas"],
  "kecepatanWifi": "50 Mbps",
  "rating": 4.7,
  "jumlahUlasan": 128,
  "skorNugas": 9,
  "deskripsi": "...",
  "gambar": "https://...",
  "mapsUrl": "https://..."
}
```

Seluruh kategori tidak disimpan sebagai data terpisah, melainkan dihasilkan dengan menyaring field di atas. Sebagai contoh, kategori "Buka 24 Jam" menyaring `buka24Jam == true`, dan kategori "Harga Mahasiswa" menyaring `hargaMin <= 12000`. Pendekatan ini membuat data antar halaman tetap terhubung dari satu sumber yang sama.

### Sumber Data

Seluruh data cafe pada aplikasi ini adalah **data dummy yang disusun sendiri** untuk keperluan tugas, bukan hasil pengambilan dari basis data usaha yang sebenarnya. Nama cafe, harga, dan kecepatan WiFi merupakan contoh, sedangkan nama kawasan (Dinoyo, Sumbersari, Tlogomas, Soekarno-Hatta, Ijen, Araya, Sigura-gura) dan alamat kampus adalah lokasi nyata di Kota Malang.

Alasan menggunakan data dummy: tidak tersedia API publik yang memuat informasi khusus tempat nugas beserta detail fasilitasnya seperti ketersediaan colokan dan kecepatan WiFi. Google Places API dapat menyediakan sebagian data, namun memerlukan kartu kredit untuk pendaftaran dan tidak memuat atribut yang dibutuhkan aplikasi ini.

Untuk pengembangan lanjutan, data dapat diganti dengan hasil observasi langsung terhadap cafe di Kota Malang, lalu diunggah ke MockAPI.io atau disimpan sebagai berkas JSON pada repositori GitHub.

### Daftar Perguruan Tinggi

Aplikasi mencakup sebelas perguruan tinggi di Kota Malang, didefinisikan pada `lib/models/kampus.dart`.

Negeri dan kedinasan: UB (Jl. Veteran), UM (Jl. Semarang No. 5), UIN Maulana Malik Ibrahim (Jl. Gajayana No. 50), Polinema (Jl. Soekarno Hatta), dan Poltekkes Kemenkes Malang (Jl. Besar Ijen).

Swasta: UMM (Jl. Raya Tlogomas), BINUS @Malang (Kawasan Araya), UNISMA (Jl. MT Haryono), UNMER (Jl. Terusan Dieng), ITN Malang (Jl. Bendungan Sigura-gura), dan Universitas Ma Chung (Villa Puncak Tidar).

Setiap kampus dipastikan memiliki sekurang-kurangnya satu cafe pada data, sehingga tidak ada filter yang menghasilkan daftar kosong.

---

## Cara Menjalankan Aplikasi

**Prasyarat:** Flutter SDK versi 3.0 atau lebih baru, dan Android Studio atau VS Code dengan ekstensi Flutter.

1. Ekstrak folder proyek, lalu buka di VS Code.

2. Buka terminal di dalam folder proyek dan jalankan:

   ```bash
   flutter pub get
   ```

3. Jika folder platform (`android/`, `ios/`) belum ada, hasilkan terlebih dahulu dengan perintah berikut di dalam folder proyek:

   ```bash
   flutter create .
   ```

4. Pastikan emulator sudah berjalan atau perangkat Android sudah terhubung, lalu jalankan:

   ```bash
   flutter run
   ```

5. Untuk memeriksa kesiapan lingkungan pengembangan:

   ```bash
   flutter doctor
   ```

Aplikasi tetap dapat dijalankan tanpa koneksi internet. Gambar cafe diambil dari internet, namun apabila gagal dimuat akan otomatis digantikan placeholder berikon kopi.

---

## Rencana Pengembangan Berikutnya

Integrasi API sudah disiapkan sejak awal. Berkas `lib/services/cafe_service.dart` memuat versi API dalam bentuk komentar. Untuk beralih dari JSON lokal ke API, cukup aktifkan package `http` pada `pubspec.yaml`, ganti isi metode `ambilSemuaCafe()`, dan tambahkan izin internet pada `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Seluruh halaman tidak perlu diubah, karena halaman hanya berkomunikasi dengan `CafeService` dan tidak mengakses sumber data secara langsung.

Pengembangan lain yang direncanakan: menyimpan daftar favorit secara permanen, pencarian yang berfungsi penuh, dan membuka lokasi langsung di aplikasi Google Maps.
