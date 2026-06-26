import 'package:flutter/material.dart';

class RecoveryScreen extends StatefulWidget {
  const RecoveryScreen({super.key});

  @override
  State<RecoveryScreen> createState() => _RecoveryScreenState();
}

class _RecoveryScreenState extends State<RecoveryScreen> {
  bool _isLoading = false;

  void _submitRecovery() async {
    setState(() {
      _isLoading = true;
    });

    // Simulando el retraso de red
    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      _showSuccessDialog(context);
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return Dialog(
          backgroundColor: theme.colorScheme.surface, // surface-container-lowest
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: theme.colorScheme.onSecondaryContainer,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '¡Correo Enviado!',
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Revisa tu bandeja de entrada. Te hemos enviado un enlace para restablecer tu contraseña.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cierra el diálogo
                      Navigator.of(context).pop(); // Vuelve al inicio de sesión
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text('Entendido'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo de la marca
                  Image.network(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuDsQ8yQtRi4ntI09YZoOXO-5aPc3CkPiYjLj-8XBKbS9Iq9nXR9GqRv74FkVwgYeAR5uw7QYOADx-vPSgsbSOVCEEi3gh8aE5wGVQATKi_7me2TIRl7oHqI3KCpEZby-7N4HD9wjaJulhIX97ao9GDYz9wdSdM5j5zXmsNRTgj4v6cLyiqFofAJqqM37_OwRBM9c3tH2x7rntlDWwYmoJE3tA9j9aOSTcNkh1YBHQXOFDkI-7k4yKysiujUJnNB4qEYY3aQgWJkgKKO',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 32),

                  // Tarjeta de contenido principal
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
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
                        // Encabezado
                        Text(
                          'Recuperar Contraseña',
                          style: theme.textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ingresa tu correo electrónico y te enviaremos las instrucciones para restablecer tu acceso.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // Formulario
                        Text(
                          'EMAIL',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'ejemplo@gmail.com',
                            prefixIcon: const Icon(Icons.mail_outline),
                            fillColor: theme.colorScheme.surfaceContainerLow,
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Botón de Enviar
                        ElevatedButton(
                          onPressed: _isLoading ? null : _submitRecovery,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Enviar Instrucciones'),
                                    SizedBox(width: 8),
                                    Icon(Icons.send, size: 18),
                                  ],
                                ),
                        ),

                        // Acción Secundaria
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 24),
                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back, size: 18),
                            label: const Text('Volver al Inicio'),
                            style: TextButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
                              textStyle: theme.textTheme.labelMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Footer
                  const SizedBox(height: 32),
                  Text(
                    'SEGUROS ELITE • ID: 4492',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.outline,
                      letterSpacing: 2.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurfaceVariant,
                          textStyle: theme.textTheme.bodySmall,
                        ),
                        child: const Text('Ayuda'),
                      ),
                      Text(
                        '•',
                        style: TextStyle(color: theme.colorScheme.outlineVariant),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurfaceVariant,
                          textStyle: theme.textTheme.bodySmall,
                        ),
                        child: const Text('Privacidad'),
                      ),
                    ],
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
