import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/providers/notificaciones_provider.dart';

class NotificacionesScreen extends StatefulWidget {
  const NotificacionesScreen({super.key});

  @override
  State<NotificacionesScreen> createState() => _NotificacionesScreenState();
}

class _NotificacionesScreenState extends State<NotificacionesScreen> {
  bool _isSaving = false;

  void _guardarCambios() async {
    setState(() => _isSaving = true);
    await context.read<NotificacionesProvider>().saveSettings();
    if (!mounted) return;
    setState(() => _isSaving = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 8),
            Text('¡Guardado!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<NotificacionesProvider>();

    if (!provider.isLoaded) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(title: const Text('Configuración de Notificaciones')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Configuración de Notificaciones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.colorScheme.primary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: theme.colorScheme.outlineVariant.withOpacity(0.5), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Elige qué alertas deseas recibir para mantenerte al tanto de tu cartera.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 24),
                
                _buildSection(
                  'NOTIFICACIONES DE CARTERA',
                  [
                    _buildSwitchTile('Nuevas Pólizas Emitidas', provider.nuevasPolizas, (v) => context.read<NotificacionesProvider>().updateNuevasPolizas(v)),
                    const Divider(height: 1),
                    _buildSwitchTile('Próximas Renovaciones', provider.renovaciones, (v) => context.read<NotificacionesProvider>().updateRenovaciones(v)),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSection(
                  'GESTIÓN DE COBRANZAS',
                  [
                    _buildSwitchTile('Pagos Rechazados', provider.pagosRechazados, (v) => context.read<NotificacionesProvider>().updatePagosRechazados(v)),
                    const Divider(height: 1),
                    _buildSwitchTile('Pólizas con Deuda', provider.polizasConDeuda, (v) => context.read<NotificacionesProvider>().updatePolizasConDeuda(v)),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSection(
                  'SINIESTROS',
                  [
                    _buildSwitchTile('Actualización de Estado', provider.actualizacionSiniestros, (v) => context.read<NotificacionesProvider>().updateActualizacionSiniestros(v)),
                    const Divider(height: 1),
                    _buildSwitchTile('Nuevos Siniestros Reportados', provider.nuevosSiniestros, (v) => context.read<NotificacionesProvider>().updateNuevosSiniestros(v)),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSection(
                  'CANALES DE ENVÍO',
                  [
                    _buildSwitchTile('Notificaciones Push', provider.notificacionesPush, (v) => context.read<NotificacionesProvider>().updateNotificacionesPush(v)),
                    const Divider(height: 1),
                    _buildSwitchTile('Correo Electrónico', provider.correoElectronico, (v) => context.read<NotificacionesProvider>().updateCorreoElectronico(v)),
                  ],
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _isSaving ? null : _guardarCambios,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Guardar Cambios', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF4FF), // surface-container-low
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5))),
            ),
            child: Text(
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: Theme.of(context).colorScheme.primary,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Theme.of(context).colorScheme.outlineVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
