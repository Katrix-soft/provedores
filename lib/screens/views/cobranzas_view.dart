import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CobranzasView extends StatefulWidget {
  const CobranzasView({super.key});

  @override
  State<CobranzasView> createState() => _CobranzasViewState();
}

class _CobranzasViewState extends State<CobranzasView> {
  bool _isLoading = true;
  List<dynamic> _debitoItems = [];
  List<dynamic> _efectivoItems = [];
  double _totalMorosidad = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCobranzas();
  }

  Future<void> _loadCobranzas() async {
    setState(() => _isLoading = true);
    try {
      final alertsData = await apiService.get('/alertas/vencimiento');
      final alertsList = alertsData as List<dynamic>? ?? [];
      
      // Filtrar impagos
      final impagos = alertsList.where((a) => a['tipo_alerta'] == 'impago').toList();
      
      double sum = 0.0;
      for (var item in impagos) {
        sum += ((item['premio'] ?? 0.0) as num).toDouble();
      }

      // Clasificar dinámicamente: Automotor y Vida suelen ser por débito automático; el resto por efectivo
      final debito = impagos.where((a) {
        final ramo = (a['ramo'] ?? '').toString().toLowerCase();
        return ramo.contains('auto') || ramo.contains('vida');
      }).toList();

      final efectivo = impagos.where((a) {
        final ramo = (a['ramo'] ?? '').toString().toLowerCase();
        return !ramo.contains('auto') && !ramo.contains('vida');
      }).toList();

      setState(() {
        _totalMorosidad = sum;
        _debitoItems = debito;
        _efectivoItems = efectivo;
        _isLoading = false;
      });
    } catch (e) {
      print('Error al cargar cobranzas: $e');
      // Fallback si falla (modo offline)
      setState(() {
        _totalMorosidad = 1245800.0;
        _debitoItems = [
          {'cliente_nombre': 'Carlos Alberto Mendez', 'nro_poliza': 'AUTO-49502', 'vigencia_hasta': '12/10', 'premio': 45200.0, 'ramo': 'Automotor'},
          {'cliente_nombre': 'Lucía Fernandez', 'nro_poliza': 'VIDA-22104', 'vigencia_hasta': '15/10', 'premio': 12800.0, 'ramo': 'Vida'},
        ];
        _efectivoItems = [
          {'cliente_nombre': 'Roberto Gomez', 'nro_poliza': 'HOGAR-8849', 'vigencia_hasta': '30/09', 'premio': 18400.0, 'ramo': 'Hogar'},
          {'cliente_nombre': 'Marta Sanchez', 'nro_poliza': 'AUTO-3302', 'vigencia_hasta': '02/10', 'premio': 34500.0, 'ramo': 'Automotor'},
        ];
        _isLoading = false;
      });
    }
  }

  String _formatCurrency(double value) {
    return '\$ ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final isTablet = MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width < 1024;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final totalImpagos = _debitoItems.length + _efectivoItems.length;
    final double ratioEfectivo = totalImpagos > 0 ? (_efectivoItems.length / totalImpagos) : 0.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: _loadCobranzas,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                ],
              ),
              
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
                    value: _formatCurrency(_totalMorosidad),
                    valueColor: const Color(0xFFBA1A1A), // error
                    subtitle: '$totalImpagos pólizas pendientes de pago hoy.',
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
                    value: '${_debitoItems.length} Pólizas',
                    subtitle: 'Pendientes de reintento automático.',
                    accentColor: theme.colorScheme.primary,
                  ),
                  _buildMetricCard(
                    context,
                    title: 'DEUDA EN EFECTIVO',
                    value: '${_efectivoItems.length} Pólizas',
                    valueColor: theme.colorScheme.secondary,
                    customSubtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: ratioEfectivo,
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
                    child: Text('${_debitoItems.length} Casos', style: theme.textTheme.labelMedium),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_debitoItems.isEmpty)
                const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Text('No hay rechazos de débito automático registrados.')))
              else
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isDesktop || isTablet ? 2 : 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: isDesktop || isTablet ? 3.5 : 2.5,
                  children: _debitoItems.map((item) {
                    final double premio = ((item['premio'] ?? 0.0) as num).toDouble();
                    return _buildDebitItem(
                      context,
                      item['cliente_nombre'] ?? 'Cliente',
                      'Póliza: ${item['nro_poliza']} | Ramo: ${item['ramo'] ?? 'General'}',
                      _formatCurrency(premio),
                      'Rechazo: Sin Fondos',
                    );
                  }).toList(),
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
                    child: Text('${_efectivoItems.length} Casos', style: theme.textTheme.labelMedium),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (_efectivoItems.isEmpty)
                const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 24), child: Text('No hay cobranzas en efectivo pendientes.')))
              else
                Container(
                  width: double.infinity,
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
                        columnSpacing: 24,
                        horizontalMargin: 16,
                        headingRowColor: WidgetStateProperty.all(const Color(0xFFEFF4FF)), // surface-container-low
                        columns: const [
                          DataColumn(label: Text('CLIENTE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF424754)))),
                          DataColumn(label: Text('ESTADO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF424754)))),
                          DataColumn(label: Text('MONTO', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF424754)))),
                          DataColumn(label: Text('ACCIÓN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF424754)))),
                        ],
                        rows: _efectivoItems.map((item) {
                          final double premio = ((item['premio'] ?? 0.0) as num).toDouble();
                          final int dias = ((item['dias_restantes'] ?? 10) as num).toInt();
                          final bool isUrgent = dias <= 0 || item['urgencia'] == 0;
                          
                          return _buildTableRow(
                            context,
                            item['cliente_nombre'] ?? 'Cliente',
                            '${item['ramo'] ?? 'General'} - Póliza ${item['nro_poliza']}',
                            isUrgent ? 'VENCIDO CON DEUDA' : 'VENCE PRONTO',
                            isUrgent,
                            _formatCurrency(premio),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              
              const SizedBox(height: 80), // Space for FAB and Bottom Nav
            ],
          ),
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
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isUrgent ? const Color(0xFFFFDAD6) : const Color(0xFFD3E4FE),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
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
