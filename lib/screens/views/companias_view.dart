import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/providers/compania_provider.dart';
import '../../data/models/compania_model.dart';
import '../compania_detalle_screen.dart';

class CompaniasView extends StatelessWidget {
  const CompaniasView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    final companias = context.watch<CompaniaProvider>().companias;

    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Aseguradoras Asociadas',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          Expanded(
            child: isDesktop
                ? GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: companias.length,
                    itemBuilder: (context, index) {
                      return _buildCompaniaCard(context, companias[index]);
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: companias.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: _buildCompaniaCard(context, companias[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompaniaCard(BuildContext context, Compania compania) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CompaniaDetalleScreen(compania: compania),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: compania.primaryColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.3)),
                        image: DecorationImage(
                          image: NetworkImage(compania.logoUrl),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      compania.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0B1C30),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${compania.totalPolicies} Pólizas Activas',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
