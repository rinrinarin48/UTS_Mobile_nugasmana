import 'package:flutter/material.dart';
import 'pages/main_shell.dart';
import 'services/auth_service.dart';
import 'services/favorite_service.dart';
import 'theme/app_theme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FavoriteService.muat();
  await AuthService.muat();

  runApp(const NugasManaApp());
}

class NugasManaApp extends StatelessWidget {
  const NugasManaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NugasMana',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const MainShell(),
    );
  }
}
