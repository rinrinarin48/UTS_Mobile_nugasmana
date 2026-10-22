import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _sandiCtrl = TextEditingController();

  bool _modeDaftar = false;
  bool _sandiTersembunyi = true;
  bool _sedangProses = false;
  String? _pesanError;

  @override
  void dispose() {
    _namaCtrl.dispose();
    _emailCtrl.dispose();
    _sandiCtrl.dispose();
    super.dispose();
  }

  Future<void> _kirim() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _sedangProses = true;
      _pesanError = null;
    });

    final hasil = _modeDaftar
        ? await AuthService.daftar(
            _namaCtrl.text,
            _emailCtrl.text,
            _sandiCtrl.text,
          )
        : await AuthService.login(_emailCtrl.text, _sandiCtrl.text);

    if (!mounted) return;
    setState(() {
      _sedangProses = false;
      _pesanError = hasil;
    });

    if (hasil == null) Navigator.pop(context);
  }

  
  void _isiAkunDemo() {
    setState(() {
      _modeDaftar = false;
      _emailCtrl.text = AuthService.emailDemo;
      _sandiCtrl.text = AuthService.sandiDemo;
      _pesanError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.krim,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.teksUtama),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.kopi,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.local_cafe_rounded,
                        color: AppColors.jeruk, size: 34),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  _modeDaftar ? 'Buat Akun Baru' : 'Masuk ke NugasMana',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.teksUtama,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _modeDaftar
                      ? 'Daftar untuk menyimpan cafe favoritmu'
                      : 'Masuk untuk menyimpan cafe favoritmu',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.teksSekunder,
                  ),
                ),
                const SizedBox(height: 28),

                if (_modeDaftar) ...[
                  _buildKolom(
                    controller: _namaCtrl,
                    label: 'Nama Lengkap',
                    ikon: Icons.person_outline,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Nama tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 14),
                ],

                _buildKolom(
                  controller: _emailCtrl,
                  label: 'Email',
                  ikon: Icons.mail_outline,
                  tipe: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!v.contains('@')) return 'Format email tidak benar';
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                _buildKolom(
                  controller: _sandiCtrl,
                  label: 'Kata Sandi',
                  ikon: Icons.lock_outline,
                  sandi: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Kata sandi tidak boleh kosong';
                    }
                    if (v.length < 6) return 'Minimal 6 karakter';
                    return null;
                  },
                ),

                if (_pesanError != null) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            size: 16, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _pesanError!,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _sedangProses ? null : _kirim,
                  child: _sedangProses
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(_modeDaftar ? 'Daftar' : 'Masuk'),
                ),
                const SizedBox(height: 14),

                TextButton(
                  onPressed: () => setState(() {
                    _modeDaftar = !_modeDaftar;
                    _pesanError = null;
                  }),
                  child: Text(
                    _modeDaftar
                        ? 'Sudah punya akun? Masuk di sini'
                        : 'Belum punya akun? Daftar di sini',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.kopi,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                if (!_modeDaftar) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.putih,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Akun contoh untuk pengujian',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.teksUtama,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${AuthService.emailDemo}\nKata sandi: ${AuthService.sandiDemo}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 11,
                            height: 1.5,
                            color: AppColors.teksSekunder,
                          ),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: _isiAkunDemo,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.kopi,
                            side: const BorderSide(color: AppColors.kopi),
                            minimumSize: const Size(0, 34),
                          ),
                          child: const Text(
                            'Isi otomatis',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKolom({
    required TextEditingController controller,
    required String label,
    required IconData ikon,
    bool sandi = false,
    TextInputType? tipe,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: tipe,
      obscureText: sandi && _sandiTersembunyi,
      validator: validator,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
            fontSize: 13, color: AppColors.teksSekunder),
        prefixIcon: Icon(ikon, size: 19, color: AppColors.teksSekunder),
        suffixIcon: sandi
            ? IconButton(
                icon: Icon(
                  _sandiTersembunyi
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 19,
                  color: AppColors.teksSekunder,
                ),
                onPressed: () =>
                    setState(() => _sandiTersembunyi = !_sandiTersembunyi),
              )
            : null,
        filled: true,
        fillColor: AppColors.putih,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.jeruk, width: 1.5),
        ),
      ),
    );
  }
}
