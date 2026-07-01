import 'package:flutter/material.dart';
import '../data/services/api_service.dart';
import 'recovery_screen.dart';
import 'request_access_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              child: Form(
                key: _formKey,
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
                      color: theme.colorScheme.surface, // surface-container-lowest equivalent
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000), // 0.05 opacity
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Email Field
                        Text(
                          'EMAIL',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Ingresá tu email';
                            if (!v.contains('@')) return 'Email inválido';
                            return null;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Ejemplo@gmail.com',
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Password Field
                        Text(
                          'CONTRASEÑA',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Ingresá tu contraseña';
                            if (v.length < 6) return 'Mínimo 6 caracteres';
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : () async {
                              if (!_formKey.currentState!.validate()) return;
                              setState(() => _isLoading = true);
                              await Future.delayed(const Duration(milliseconds: 800));
                              if (!mounted) return;
                              setState(() => _isLoading = false);

                              final emailInput = _emailController.text.trim();
                              final passInput = _passwordController.text;

                              try {
                                final exito = await apiService.login(emailInput, passInput);
                                if (exito) {
                                  if (!mounted) return;
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                                  );
                                } else {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: const Color(0xFFBA1A1A),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      content: const Row(
                                        children: [
                                          Icon(Icons.error_outline, color: Colors.white),
                                          SizedBox(width: 8),
                                          Text('Email/Usuario o contraseña incorrectos', style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: const Color(0xFFBA1A1A),
                                    content: Text('Error de conexión a la API: $e'),
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
                        const SizedBox(height: 24),
                        
                        // Links
                        const Divider(),
                        const SizedBox(height: 24),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const RecoveryScreen(),
                                ),
                              );
                            },
                            child: Text(
                              '¿Olvidaste tu contraseña?',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿No tienes cuenta?',
                              style: theme.textTheme.bodySmall,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const RequestAccessScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Solicitar acceso',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  // Footer
                  Text(
                    '© 2026 JC Organizadores. Sistema de Gestión Profesional.',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),       // Column
            ),         // Form
          ),           // ConstrainedBox
        ),             // SingleChildScrollView
      ),               // Center
    ),                 // SafeArea
    );
  }
}
