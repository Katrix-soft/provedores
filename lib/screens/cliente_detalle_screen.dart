import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/models/cliente.dart';

class ClienteDetalleScreen extends StatelessWidget {
  final Cliente cliente;
  const ClienteDetalleScreen({super.key, required this.cliente});

  Future<void> _llamar() async {
    final uri = Uri(scheme: 'tel', path: cliente.telefono);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _email() async {
    final uri = Uri(scheme: 'mailto', path: cliente.email);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _whatsapp() async {
    final numero = cliente.whatsapp.replaceAll(RegExp(r'[^\d]'), '');
    final uri = Uri.parse('https://wa.me/$numero?text=Hola%20${Uri.encodeComponent(cliente.nombre)},%20le%20contactamos%20de%20JC%20Organizadores%20Seguros.');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Row(
        children: [
          if (isDesktop) _buildSideMenu(context),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileSection(context),
                            const SizedBox(height: 32),
                            _buildPoliciesSection(context),
                            const SizedBox(height: 32),
                            _buildHistorySection(context),
                            const SizedBox(height: 48),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              Text('Detalle de Cliente', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (v) {
              if (v == 'editar') {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Editar cliente — próximamente')));
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'editar', child: Row(children: [Icon(Icons.edit, size: 18), SizedBox(width: 8), Text('Editar')])),
              const PopupMenuItem(value: 'eliminar', child: Row(children: [Icon(Icons.delete, size: 18, color: Color(0xFFBA1A1A)), SizedBox(width: 8), Text('Eliminar', style: TextStyle(color: Color(0xFFBA1A1A)))])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar con estado
          Stack(
            children: [
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  cliente.iniciales,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: cliente.isPending ? const Color(0xFFBA1A1A) : const Color(0xFF006C49),
                    shape: BoxShape.circle,
                    border: const Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: isMobile ? 0 : 24, height: isMobile ? 16 : 0),
          if (isMobile)
            _buildProfileInfo(context, isMobile)
          else
            Expanded(child: _buildProfileInfo(context, isMobile)),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(BuildContext context, bool isMobile) {
    final theme = Theme.of(context);
    return Column(
              crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
              children: [
                Text(
                  cliente.nombre,
                  style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: isMobile ? TextAlign.center : TextAlign.left,
                ),
                const SizedBox(height: 4),
                Text('DNI: ${cliente.dni}', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
                  children: [
                    Icon(Icons.mail_outline, size: 14, color: theme.colorScheme.outline),
                    const SizedBox(width: 4),
                    Text(cliente.email, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _llamar,
                      icon: const Icon(Icons.call, size: 16),
                      label: const Text('LLAMAR'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _email,
                      icon: const Icon(Icons.mail, size: 16),
                      label: const Text('MENSAJE'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        side: BorderSide(color: Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _whatsapp,
                      icon: const Icon(Icons.chat, size: 16),
                      label: const Text('WHATSAPP'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006C49),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            );
  }

  Widget _buildPoliciesSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    if (cliente.polizas.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
        ),
        child: const Center(child: Text('Sin pólizas vigentes')),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text('Pólizas Vigentes (${cliente.polizas.length})', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isDesktop ? 2 : 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: isDesktop ? 1.6 : 1.4,
          children: cliente.polizas.map((p) => _buildPolicyCard(context, p)).toList(),
        ),
      ],
    );
  }

  Widget _buildPolicyCard(BuildContext context, Poliza poliza) {
    final theme = Theme.of(context);
    final isActive = poliza.estado == EstadoCliente.activo;
    final accentColor = isActive ? theme.colorScheme.primary : const Color(0xFF6063EE);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(poliza.tipo.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: accentColor, letterSpacing: 0.5)),
                            const SizedBox(height: 4),
                            Text(poliza.compania, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF6CF8BB) : const Color(0xFFFFDAD6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isActive ? 'ACTIVO' : 'PENDIENTE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isActive ? const Color(0xFF00714D) : const Color(0xFF93000A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildRow(context, 'Nro. Póliza', poliza.numero),
                        _buildRow(context, 'Vencimiento', poliza.vencimiento),
                        if (poliza.premio.isNotEmpty || poliza.sumaAsegurada.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              children: [
                                if (poliza.premio.isNotEmpty)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('PREMIO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.colorScheme.outline)),
                                        Text(poliza.premio, style: theme.textTheme.titleLarge?.copyWith(color: accentColor, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                if (poliza.sumaAsegurada.isNotEmpty)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('SUMA ASEG.', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.colorScheme.outline)),
                                        Text(poliza.sumaAsegurada, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        if (!isActive)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: const Color(0xFFE5EEFF), borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const Icon(Icons.warning, color: Color(0xFFBA1A1A), size: 16),
                                const SizedBox(width: 8),
                                Expanded(child: Text('Pago atrasado. Contactar cliente.', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildHistorySection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Text('Historial Reciente', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        ),
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
            boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 8, offset: Offset(0, 2))],
          ),
          child: cliente.historial.isEmpty
              ? const Center(child: Padding(padding: EdgeInsets.all(16), child: Text('Sin historial registrado')))
              : Stack(
                  children: [
                    Positioned(
                      left: 11,
                      top: 8,
                      bottom: 8,
                      child: Container(width: 2, color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
                    ),
                    Column(
                      children: [
                        for (int i = 0; i < cliente.historial.length; i++) ...[
                          _buildTimelineItem(context, cliente.historial[i]),
                          if (i < cliente.historial.length - 1) const SizedBox(height: 24),
                        ],
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(BuildContext context, HistorialItem item) {
    final theme = Theme.of(context);
    Color color;
    IconData icon;
    switch (item.tipo) {
      case 'success': color = theme.colorScheme.secondary; icon = Icons.check; break;
      case 'error':   color = const Color(0xFFBA1A1A); icon = Icons.report_problem; break;
      default:        color = theme.colorScheme.primaryContainer; icon = Icons.mail;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Icon(icon, size: 13, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.titulo, style: theme.textTheme.labelMedium),
              const SizedBox(height: 2),
              Text(item.descripcion, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 4),
              Text(item.fecha, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.colorScheme.outline)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSideMenu(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(right: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('Seguros Globales', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFD8E2FF)),
                  alignment: Alignment.center,
                  child: Text('AP', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Agente Profesional', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text('ID: 28491', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildNavItem(context, Icons.dashboard, 'Dashboard', false),
          _buildNavItem(context, Icons.payments, 'Cobranzas', false),
          _buildNavItem(context, Icons.groups, 'Clientes', true),
          _buildNavItem(context, Icons.report_problem, 'Siniestros', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String title, bool isSelected) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: isSelected ? theme.colorScheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => isSelected ? null : Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 16),
                Text(title, style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
