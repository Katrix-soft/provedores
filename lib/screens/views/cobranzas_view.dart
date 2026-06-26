import 'package:flutter/material.dart';

class CobranzasView extends StatelessWidget {
  const CobranzasView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final isTablet = MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width < 1024;

    return Scaffold(
      backgroundColor: Colors.transparent, // Let parent handle background
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumbs & Header
            Row(
              children: [
                Text('Cobranzas', style: theme.textTheme.labelMedium),
                const Icon(Icons.chevron_right, size: 16),
                Text('Falta de Pago', style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                )),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gestión de Cobranzas',
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Resumen de pagos pendientes y pólizas en riesgo.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (MediaQuery.of(context).size.width >= 600)
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.download, size: 18),
                    label: const Text('Exportar PDF'),
                  ),
              ],
            ),
            if (MediaQuery.of(context).size.width < 600) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Exportar PDF'),
                ),
              ),
            ],
            
            const SizedBox(height: 24),

            // Bento Summary Metrics
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isDesktop ? 4 : (isTablet ? 2 : 1),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isDesktop ? 1.8 : 2.0,
              children: [
                _buildMetricCard(
                  context,
                  title: 'TOTAL MOROSIDAD',
                  value: '\$ 1.245.800',
                  valueColor: const Color(0xFFBA1A1A), // error
                  subtitle: '24 pólizas pendientes de pago hoy.',
                  accentColor: const Color(0xFFBA1A1A), // error
                  spanTwo: isDesktop || isTablet,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDAD6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.trending_up, size: 14, color: Color(0xFF93000A)),
                        SizedBox(width: 4),
                        Text('+12%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF93000A))),
                      ],
                    ),
                  ),
                ),
                _buildMetricCard(
                  context,
                  title: 'RECHAZADAS POR DÉBITO',
                  value: '12 Pólizas',
                  subtitle: 'Pendientes de reintento automático.',
                  accentColor: theme.colorScheme.primary,
                ),
                _buildMetricCard(
                  context,
                  title: 'DEUDA EN EFECTIVO',
                  value: '10 Pólizas',
                  valueColor: theme.colorScheme.secondary,
                  customSubtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 0.33,
                        backgroundColor: const Color(0xFFDCE9FF), // surface-container-high
                        color: theme.colorScheme.secondary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  accentColor: theme.colorScheme.secondary,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Section: Débito
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8E2FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.credit_card, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 8),
                Text('Pendientes Débito Automático', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE9FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('14 Casos', style: theme.textTheme.labelMedium),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isDesktop || isTablet ? 2 : 1,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isDesktop || isTablet ? 3.5 : 2.5,
              children: [
                _buildDebitItem(context, 'Carlos Alberto Mendez', 'Póliza: AUTO-49502 | Vto: 12/10', '\$ 45.200', 'Rechazo: Fondos'),
                _buildDebitItem(context, 'Lucía Fernandez', 'Póliza: VIDA-22104 | Vto: 15/10', '\$ 12.800', 'Rechazo: Vencimiento'),
              ],
            ),

            const SizedBox(height: 32),

            // Section: Efectivo
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6FFBBE), // secondary-fixed
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.payments, color: theme.colorScheme.secondary),
                ),
                const SizedBox(width: 8),
                Text('Cobranza en Efectivo', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE9FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text('10 Casos', style: theme.textTheme.labelMedium),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 12, // Reducido aún más
                    horizontalMargin: 12,
                    headingRowColor: WidgetStateProperty.all(const Color(0xFFEFF4FF)), // surface-container-low
                    columns: const [
                      DataColumn(label: Text('CLIENTE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF424754)))),
                      DataColumn(label: Text('ESTADO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF424754)))),
                      DataColumn(label: Text('MONTO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF424754)))),
                      DataColumn(label: Text('ACCIÓN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF424754)))),
                    ],
                    rows: [
                      _buildTableRow(context, 'Roberto Gomez', 'Hogar Integral - Póliza 8849', 'VENCIDO 15 DÍAS', true, '\$ 18.400'),
                      _buildTableRow(context, 'Marta Sanchez', 'Auto Premium - Póliza 3302', 'VENCIDO 2 DÍAS', false, '\$ 34.500'),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 80), // Space for FAB and Bottom Nav
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    String? subtitle,
    Widget? customSubtitle,
    required Color accentColor,
    Color? valueColor,
    bool spanTwo = false,
    Widget? trailing,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: theme.textTheme.labelMedium?.copyWith(color: const Color(0xFF424754))),
                    if (trailing != null) trailing,
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? theme.colorScheme.onSurface,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF424754),
                    ),
                  ),
                ],
                if (customSubtitle != null) customSubtitle,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDebitItem(BuildContext context, String name, String details, String amount, String reason) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFDCE9FF),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(details, style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF424754))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(amount, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFBA1A1A))),
              Text(reason, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF727785))),
            ],
          ),
        ],
      ),
    );
  }

  DataRow _buildTableRow(BuildContext context, String name, String details, String status, bool isUrgent, String amount) {
    final theme = Theme.of(context);
    return DataRow(
      cells: [
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              Text(details, style: const TextStyle(fontSize: 12, color: Color(0xFF424754))),
            ],
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), // Achicamos el padding
            decoration: BoxDecoration(
              color: isUrgent ? const Color(0xFFFFDAD6) : const Color(0xFFD3E4FE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10, // Achicamos un punto la fuente
                fontWeight: FontWeight.bold,
                color: isUrgent ? const Color(0xFF93000A) : const Color(0xFF424754),
              ),
            ),
          ),
        ),
        DataCell(
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.call, size: 20),
                color: theme.colorScheme.primary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.chat, size: 20),
                color: theme.colorScheme.secondary,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
