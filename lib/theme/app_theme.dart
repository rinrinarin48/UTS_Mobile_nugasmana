import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Kumpulan token warna aplikasi NugasMana.
/// Nilai warna diambil langsung dari sistem desain yang dibuat di Figma.
class AppColors {
  static const Color kopi = Color(0xFF4E342E); // primary / dark brown
  static const Color latte = Color(0xFF7B5E57); // primary light
  static const Color krim = Color(0xFFF5EDE3); // background
  static const Color putih = Color(0xFFFFFFFF); // surface
  static const Color jeruk = Color(0xFFE8912D); // accent
  static const Color hijau = Color(0xFF3D8361); // success
  static const Color teksUtama = Color(0xFF2B2118);
  static const Color teksSekunder = Color(0xFF8A7968);
}

/// Konfigurasi tema global aplikasi.
class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.krim,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.kopi,
        primary: AppColors.kopi,
        secondary: AppColors.jeruk,
        surface: AppColors.putih,
      ),
      // Huruf Poppins diambil dari package google_fonts dan diterapkan
      // sebagai fontFamily global, sehingga seluruh teks pada aplikasi
      // memakainya tanpa perlu menyebutkannya satu per satu.
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.teksUtama,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.teksUtama,
        ),
        bodyMedium: TextStyle(fontSize: 14, color: AppColors.teksUtama),
        bodySmall: TextStyle(fontSize: 12, color: AppColors.teksSekunder),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.jeruk,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  /// Radius dan bayangan standar untuk kartu.
  static BorderRadius get radiusKartu => BorderRadius.circular(16);

  static List<BoxShadow> get bayanganKartu => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          offset: const Offset(0, 4),
          blurRadius: 12,
        ),
      ];
}