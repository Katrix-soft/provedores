import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Section
                  Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuCWmWtBTOG94ebZcQp0UsJ6-0V6LVgCiuVka12SaJiSnycaDjT4UAneUW1KkNSHjdKY2UH4QqvtgyuuGMuYWv782qq8YKsON7lzY-Lfa7EUdlDMvxPzbhmId2Jk_qwzaWf6u7UtMH6nMUSSRt0utH_nlQ2XxJONaq1dz10BEbyvSu7otZUp4ZkK1A2fZ-VFkBy-HdbRQ1wWPZTOohnN6HzD64k8QIG5wNIu8a0gnSX_oa2UfXKNAIyfNRca4wtw_RPX8T81IoCGA7Eo',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bienvenido',
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gestione sus pólizas con control y precisión.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Form Card
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : () async {
                              setState(() => _isLoading = true);
                              await Future.delayed(const Duration(milliseconds: 800));
                              if (!mounted) return;
                              setState(() => _isLoading = false);

                              try {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('access_token', 'mock_token');
                                await prefs.setString('username', 'Nicolás');
                                await prefs.setString('role', 'admin');
                                await prefs.setInt('user_id', 28491);

                                if (!mounted) return;
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                                );
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: const Color(0xFFBA1A1A),
                                    content: Text('Error al inicializar sesión: $e'),
                                  ),
                                );
                              }
                            },
                            child: _isLoading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Iniciar Sesión'),
                                    SizedBox(width: 8),
                                    Icon(Icons.login),
                                  ],
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  // Footer
                  Text(
                    'Powered by Katrix © 2026',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
