import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'notificaciones_screen.dart';
import 'seguridad_screen.dart';
import 'firma_screen.dart';

class PerfilScreen extends StatelessWidget {
  final String username;
  final String role;
  final int userId;

  const PerfilScreen({
    super.key,
    required this.username,
    required this.role,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Hero Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
                    boxShadow: const [BoxShadow(color: Color(0x0D000000), blurRadius: 12, offset: Offset(0, 4))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Background
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 128,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                              gradient: LinearGradient(
                                colors: [Color(0xFF0058be), Color(0xFF213145)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -48,
                            left: 24,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                width: 96,
                                height: 96,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 4),
                                  image: const DecorationImage(
                                    image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCTIabKB45fJfFZT8sg1aLxduEgN7AhCOFzIsvmDSkF1oQKBmdkCcCBoTSyCSChn6hodGbZI9ruZjissrJ5QsF3IDVRtjA6J_W2g7JLX0xFKsM1ikBVlcQ9r38sAYjxHsXHIZPTgie5K_XSZduWWYNgACxqSIw2gLDCzotWC2Dnob-KctR1SKP16Bl51hNH5aWcclyiekEm3v5yGCDSQ9gi7Dg_7O1eT0OBqbZcPDCORCLDN0MRj7JEYCCNBeurMU-BOkLdAi8BUPh0'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 56), // Space for overlapping avatar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(username, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.verified, color: Color(0xFF0058be), size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  role == 'admin' ? 'Administrador' : 'Agente Profesional',
                                  style: theme.textTheme.labelMedium?.copyWith(color: const Color(0xFF0058be), fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),

                // Resumen de Rendimiento
                Text('RESUMEN DE RENDIMIENTO', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outline, letterSpacing: 1.2)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildMetricCard(context, 'Años de Trayectoria', '12', const Color(0xFF0058be))),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMetricCard(context, 'Pólizas Totales', '450', const Color(0xFF006c49))),
                  ],
                ),
                
                const SizedBox(height: 32),

                // Datos Personales
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF4FF), // surface-container-low
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5))),
                        ),
                        child: Text('Datos Personales', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ),
                       _buildDataRow(context, 'ID DE AGENTE', userId.toString(), Icons.badge),
                      const Divider(height: 1),
                      _buildDataRow(context, 'EMAIL / USUARIO', username, Icons.mail),
                      const Divider(height: 1),
                      _buildDataRow(context, 'TELÉFONO', '+54 11 4567-8901', Icons.call),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Configuración
                Text('CONFIGURACIÓN', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outline, letterSpacing: 1.2)),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      _buildConfigItem(
                        context,
                        'Notificaciones',
                        Icons.notifications,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const NotificacionesScreen()),
                        ),
                      ),
                      const Divider(height: 1),
                      _buildConfigItem(
                        context, 
                        'Seguridad', 
                        Icons.security,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SeguridadScreen()),
                        ),
                      ),
                      const Divider(height: 1),
                      _buildConfigItem(
                        context, 
                        'Configuración de Firma', 
                        Icons.draw,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const FirmaScreen()),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Logout Button
                OutlinedButton.icon(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                    }
                  },
                  icon: const Icon(Icons.logout, color: Color(0xFFBA1A1A)),
                  label: const Text('Cerrar Sesión', style: TextStyle(color: Color(0xFFBA1A1A), fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFBA1A1A), width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                
                const SizedBox(height: 24),
                Center(
                  child: Text('Versión 2.4.1 (Producción)', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outline)),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.labelMedium?.copyWith(color: const Color(0xFF424754))),
                const SizedBox(height: 4),
                Text(value, style: theme.textTheme.headlineMedium?.copyWith(color: color, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outline)),
              const SizedBox(height: 4),
              Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            ],
          ),
          Icon(icon, color: theme.colorScheme.outline),
        ],
      ),
    );
  }

  Widget _buildConfigItem(BuildContext context, String label, IconData icon, {VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface)),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFFC2C6D6)),
      onTap: onTap,
    );
  }
}
