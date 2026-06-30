import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'data/providers/cliente_provider.dart';
import 'data/providers/notificaciones_provider.dart';
import 'data/providers/seguridad_provider.dart';
import 'data/providers/firma_provider.dart';
import 'data/providers/compania_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const AssuranceNexusApp());
}

class AssuranceNexusApp extends StatelessWidget {
  const AssuranceNexusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClienteProvider()),
        ChangeNotifierProvider(create: (_) => NotificacionesProvider()),
        ChangeNotifierProvider(create: (_) => SeguridadProvider()),
        ChangeNotifierProvider(create: (_) => FirmaProvider()),
        ChangeNotifierProvider(create: (_) => CompaniaProvider()),
      ],
      child: MaterialApp(
        title: 'JC Organizadores',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LoginScreen(),
      ),
    );
  }
}
