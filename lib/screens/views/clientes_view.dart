import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/cliente.dart';
import '../../data/providers/cliente_provider.dart';
import '../cliente_detalle_screen.dart';

class ClientesView extends StatefulWidget {
  const ClientesView({super.key});

  @override
  State<ClientesView> createState() => _ClientesViewState();
}

class _ClientesViewState extends State<ClientesView> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _recargar() async {
    setState(() => _isLoading = true);
    await context.read<ClienteProvider>().recargar();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final isTablet = MediaQuery.of(context).size.width >= 768 && MediaQuery.of(context).size.width < 1024;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarAgregarCliente(context),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        child: const Icon(Icons.person_add),
      ),
      body: RefreshIndicator(
        onRefresh: _recargar,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                onChanged: (v) => context.read<ClienteProvider>().buscar(v),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre, DNI o póliza...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: Consumer<ClienteProvider>(
                    builder: (_, p, __) => p.busqueda.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              p.buscar('');
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filter Chips
              Consumer<ClienteProvider>(
                builder: (_, provider, __) => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(context, 'todos', 'Todos', provider),
                      const SizedBox(width: 6),
                      _buildFilterChip(context, 'vida', 'Vida', provider),
                      const SizedBox(width: 6),
                      _buildFilterChip(context, 'hogar', 'Hogar', provider),
                      const SizedBox(width: 6),
                      _buildFilterChip(context, 'automotor', 'Automotor', provider),
                      const SizedBox(width: 6),
                      _buildFilterChip(context, 'accidentes', 'Accidentes', provider),
                      const SizedBox(width: 6),
                      _buildFilterChip(context, 'empresas', 'Empresas', provider),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Contador de resultados
              Consumer<ClienteProvider>(
                builder: (_, provider, __) {
                  final count = provider.clientes.length;
                  return Row(
                    children: [
                      Text(
                        '$count ${count == 1 ? "cliente" : "clientes"}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      if (_isLoading)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),

              // Client Grid
              Consumer<ClienteProvider>(
                builder: (_, provider, __) {
                  final clientes = provider.clientes;

                  if (clientes.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 64),
                        child: Column(
                          children: [
                            Icon(Icons.search_off, size: 64, color: theme.colorScheme.outline.withOpacity(0.4)),
                            const SizedBox(height: 16),
                            Text('Sin resultados', style: theme.textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(
                              'Probá con otro nombre, DNI o póliza',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isDesktop ? 3 : (isTablet ? 2 : 1),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isDesktop ? 1.3 : (isTablet ? 1.4 : 1.7),
                    children: clientes.map((c) => _buildClientCard(context, c)).toList(),
                  );
                },
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String valor, String label, ClienteProvider provider) {
    final theme = Theme.of(context);
    final isSelected = provider.filtroRamo == valor;
    return GestureDetector(
      onTap: () => provider.filtrarPorRamo(valor),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : const Color(0xFFDCE9FF),
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [BoxShadow(color: theme.colorScheme.primary.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 2))]
              : [],
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? theme.colorScheme.onPrimary : const Color(0xFF424754),
            fontSize: 11, // Achicamos un poco la letra
            letterSpacing: 0.2, // Reducimos un poco el espaciado entre letras
          ),
        ),
      ),
    );
  }

  Widget _buildClientCard(BuildContext context, Cliente cliente) {
    final theme = Theme.of(context);
    final accentColor = _colorParaRamo(cliente.ramo, theme);

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ClienteDetalleScreen(cliente: cliente)),
      ),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
          boxShadow: const [
            BoxShadow(color: Color(0x0D000000), blurRadius: 12, offset: Offset(0, 4)),
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
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                cliente.iniciales,
                                style: TextStyle(
                                  color: accentColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cliente.nombre,
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'DNI: ${cliente.dni}',
                                    style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: cliente.isPending ? const Color(0xFFFFDAD6) : const Color(0x266CF8BB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          cliente.isPending ? 'PENDIENTE' : 'ACTIVO',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: cliente.isPending ? const Color(0xFF93000A) : const Color(0xFF005236),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Info Grid
                  Row(
                    children: [
                      Expanded(child: _buildInfoChip(context, 'PÓLIZA', cliente.polizaPrincipal)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildInfoChip(context, 'VENCE', cliente.vencimiento)),
                    ],
                  ),

                  // Contact
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.4))),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.call, size: 13, color: Color(0xFF727785)),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(cliente.telefono, style: const TextStyle(fontSize: 10, color: Color(0xFF424754)), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(Icons.mail, size: 13, color: Color(0xFF727785)),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(cliente.email, style: const TextStyle(fontSize: 10, color: Color(0xFF424754)), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: theme.colorScheme.outline)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Color _colorParaRamo(RamoPoliza ramo, ThemeData theme) {
    switch (ramo) {
      case RamoPoliza.vida:       return theme.colorScheme.secondary;
      case RamoPoliza.hogar:      return const Color(0xFF4648D4);
      case RamoPoliza.automotor:  return theme.colorScheme.primary;
      case RamoPoliza.accidentes: return const Color(0xFF9C27B0);
      case RamoPoliza.empresas:   return const Color(0xFFE65100);
    }
  }

  void _mostrarAgregarCliente(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).viewInsets.bottom + 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Nuevo Cliente', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 16),
            const TextField(decoration: InputDecoration(labelText: 'Nombre completo', prefixIcon: Icon(Icons.person))),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'DNI', prefixIcon: Icon(Icons.badge)), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Teléfono / WhatsApp', prefixIcon: Icon(Icons.phone)), keyboardType: TextInputType.phone),
            const SizedBox(height: 12),
            const TextField(decoration: InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail)), keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.save),
                label: const Text('Guardar Cliente'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
