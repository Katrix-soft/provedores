import 'package:flutter/material.dart';
import '../asistente_ia_screen.dart';
import '../compania_detalle_screen.dart';
import 'package:provider/provider.dart';
import '../../data/providers/compania_provider.dart';

class DashboardHomeView extends StatelessWidget {
  final String username;
  const DashboardHomeView({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final isTablet = MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width < 1024;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Hola, $username',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Aquí tienes el resumen de tu cartera hoy.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 24),

          // Metrics Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isDesktop ? 4 : (isTablet ? 2 : 1),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isDesktop ? 1.5 : (isTablet ? 1.5 : 2.0),
            children: [
              _buildMetricCard(
                context,
                title: 'Premio Administrado',
                value: '\$13.5M',
                subtitle: 'Cartera Total Vigente',
                icon: Icons.account_balance_wallet,
                accentColor: theme.colorScheme.primary,
                spanTwo: isDesktop || isTablet,
              ),
              _buildMetricCard(
                context,
                title: 'Clientes Activos',
                value: '8',
                customSubtitle: Row(
                  children: [
                    _buildAvatarCircle(const Color(0xFFD8E2FF)),
                    _buildAvatarCircle(const Color(0xFF6FFBBE)),
                    _buildAvatarCircle(const Color(0xFFE1E0FF)),
                    Container(
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(left: 2),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE5EEFF),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '+5',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                accentColor: theme.colorScheme.primary,
              ),
              _buildMetricCard(
                context,
                title: 'Pólizas con Deuda',
                value: '12',
                valueColor: const Color(0xFFBA1A1A), // Error color
                customSubtitle: const Row(
                  children: [
                    Icon(Icons.payments, color: Color(0xFFBA1A1A), size: 14),
                    SizedBox(width: 4),
                    Text('EN DEUDA', style: TextStyle(color: Color(0xFFBA1A1A), fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                accentColor: const Color(0xFFBA1A1A),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Solicitudes Section
          _buildSolicitudesSection(context),

          const SizedBox(height: 24),

          // Distributions Grid
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildRamosDistribution(context),
                    if (!isDesktop) const SizedBox(height: 24),
                    if (!isDesktop) _buildCompaniasDistribution(context),
                  ],
                ),
              ),
              if (isDesktop) const SizedBox(width: 16),
              if (isDesktop)
                Expanded(
                  child: _buildCompaniasDistribution(context),
                ),
            ],
          ),

          const SizedBox(height: 24),

          // Activity Section
          _buildRenewalsSection(context),
          
          const SizedBox(height: 48), // Padding for mobile bottom nav
        ],
      ),
    );
  }

  Widget _buildAvatarCircle(Color color) {
    return Container(
      width: 24,
      height: 24,
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    String? subtitle,
    Widget? customSubtitle,
    IconData? icon,
    required Color accentColor,
    Color? valueColor,
    bool spanTwo = false,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.labelMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          value,
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 32,
                            color: valueColor ?? theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    if (icon != null)
                      Icon(
                        icon,
                        color: const Color(0xFFADC6FF).withOpacity(0.5),
                        size: 36,
                      ),
                  ],
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                if (customSubtitle != null) customSubtitle,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRamosDistribution(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribución por Ramos',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildProgressRow(context, 'Automotor', '55%', 0.55, theme.colorScheme.primary),
          const SizedBox(height: 16),
          _buildProgressRow(context, 'Hogar', '25%', 0.25, theme.colorScheme.secondary),
          const SizedBox(height: 16),
          _buildProgressRow(context, 'Vida', '15%', 0.15, const Color(0xFF4648D4)), // tertiary
          const SizedBox(height: 16),
          _buildProgressRow(context, 'Otros', '5%', 0.05, theme.colorScheme.outline),
        ],
      ),
    );
  }

  Widget _buildProgressRow(BuildContext context, String label, String percentage, double value, Color color) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.labelMedium),
            Text(percentage, style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: const Color(0xFFE5EEFF),
          color: color,
          borderRadius: BorderRadius.circular(4),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildCompaniasDistribution(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pólizas por Compañía',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ...context.watch<CompaniaProvider>().companias.map((compania) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildCompanyTile(
                  context,
                  compania.name,
                  '${compania.totalPolicies} pólizas',
                  compania.icon,
                  compania.primaryColor,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompaniaDetalleScreen(compania: compania),
                      ),
                    );
                  },
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildCompanyTile(BuildContext context, String name, String count, IconData icon, Color iconColor, {VoidCallback? onTap}) {
    final theme = Theme.of(context);
    return Material(
      color: const Color(0xFFEFF4FF),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: theme.textTheme.labelMedium),
                  Text(count, style: const TextStyle(fontSize: 12, color: Color(0xFF424754))), // on-surface-variant
                ],
              ),
            ],
          ),
          const Icon(Icons.chevron_right, color: Color(0xFF424754)),
        ],
      ),
    ),
    ),
    );
  }

  Widget _buildRenewalsSection(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Próximas a Renovar',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildRenewalTile(context, '12', 'Póliza #88219', 'Cliente: Juan Pérez', isUrgent: true),
          const SizedBox(height: 12),
          _buildRenewalTile(context, '15', 'Póliza #99312', 'Cliente: Maria Gomez'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                side: BorderSide(color: theme.colorScheme.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Ver Calendario Completo', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRenewalTile(BuildContext context, String day, String title, String subtitle, {bool isUrgent = false}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5EEFF))),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isUrgent ? const Color(0xFFFFDAD6) : const Color(0xFFE5EEFF), // error-container or surface-container
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              day,
              style: TextStyle(
                color: isUrgent ? const Color(0xFF93000A) : const Color(0xFF424754),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.labelMedium),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Color(0xFF424754))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSolicitudesSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Solicitudes',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          isDesktop
              ? Row(
                  children: [
                    Expanded(child: _buildSolicitudButton(context, 'Cotización/Emisión', onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AsistenteIAScreen()));
                    })),
                    const SizedBox(width: 8),
                    Expanded(child: _buildSolicitudButton(context, 'Endoso/Operativo')),
                    const SizedBox(width: 8),
                    Expanded(child: _buildSolicitudButton(context, 'Siniestro')),
                  ],
                )
              : Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: _buildSolicitudButton(context, 'Cotización/Emisión', onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AsistenteIAScreen()));
                      }),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: _buildSolicitudButton(context, 'Endoso/Operativo'),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: _buildSolicitudButton(context, 'Siniestro'),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildSolicitudButton(BuildContext context, String text, {VoidCallback? onPressed}) {
    final theme = Theme.of(context);
    return OutlinedButton(
      onPressed: onPressed ?? () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        side: BorderSide(color: theme.colorScheme.primary),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
