import 'package:flutter/material.dart';
import '../data/models/compania_model.dart';

class CompaniaDetalleScreen extends StatelessWidget {
  final Compania compania;

  const CompaniaDetalleScreen({super.key, required this.compania});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF), // background
      appBar: AppBar(
        backgroundColor: Colors.white, // surface
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: const Color(0xFFC2C6D6), // outline-variant
            height: 1.0,
          ),
        ),
        title: Text(
          compania.name,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: compania.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2170E4), // primary-container
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://lh3.googleusercontent.com/aida-public/AB6AXuA6OJPZ-O7azNik1d_0fX-Jqhy4bSCRokTDFJkVzns70LYx5uMsZJUeDF8Zrg9kPACdwvXRB266fghemKdAE6ZYIaEzh9TGAauGVHsQ2r43wPGgdkjycVbPij3ypwyvNrn6IZLL_fjI65VlZ8GaqxX5-C4k_ub1j_E8cW6s4u0w3cKd6l3HNJqco-jzF8JFgxg-rl4YvyypSrVjiDql_cR48R1zPCkChL2YiZ48vWTQDdrsw59NBuY4wGvU5_jNX3rujmZOxzEeCPXw',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 32.0 : 16.0, vertical: 24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeroCard(context, isDesktop),
                const SizedBox(height: 24),
                _buildKPIGrid(context, isDesktop),
                const SizedBox(height: 24),
                _buildChartsAndDetails(context, isDesktop),
                const SizedBox(height: 24),
                _buildQuickActions(context),
                const SizedBox(height: 48), // Padding for bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, // surface-container-lowest
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC2C6D6)), // outline-variant
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Flex(
        direction: isDesktop ? Axis.horizontal : Axis.vertical,
        mainAxisAlignment: isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
        crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE5EEFF), // surface-container
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFC2C6D6)),
            ),
            child: Image.network(
              compania.logoUrl,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: isDesktop ? 0 : 24, width: isDesktop ? 24 : 0),
          if (isDesktop)
            Expanded(child: _buildCompanyInfo(context, isDesktop))
          else
            _buildCompanyInfo(context, isDesktop),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo(BuildContext context, bool isDesktop) {
    return Column(
      crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Text(
          compania.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0B1C30), // on-surface
          ),
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
        ),
        const SizedBox(height: 4),
        const Text(
          'Compañía Líder en Riesgos Patrimoniales',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF424754), // on-surface-variant
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Column(
              crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                const Text(
                  'PÓLIZAS TOTALES',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF424754),
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '${compania.totalPolicies}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: compania.primaryColor,
                  ),
                ),
              ],
            ),
            if (isDesktop)
              Container(
                width: 1,
                height: 40,
                color: const Color(0xFFC2C6D6),
              ),
            Column(
              crossAxisAlignment: isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                const Text(
                  'PRIMA ADMINISTRADA',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF424754),
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '\$${compania.managedPremium}M',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF006C49), // secondary
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKPIGrid(BuildContext context, bool isDesktop) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isDesktop ? 3 : 1,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isDesktop ? 1.5 : 2.0,
      children: [
        _buildKPICard(
          context,
          title: 'Retention Rate',
          value: '${compania.retentionRate}%',
          change: compania.retentionChange,
          icon: Icons.loop,
          color: const Color(0xFF0058BE), // primary
          bgColor: const Color(0xFF2170E4).withOpacity(0.1), // primary-container approx
        ),
        _buildKPICard(
          context,
          title: 'Loss Ratio (Siniestralidad)',
          value: '${compania.lossRatio}%',
          change: compania.lossRatioChange,
          icon: Icons.trending_up,
          color: const Color(0xFFBA1A1A), // error
          bgColor: const Color(0xFFFFDAD6).withOpacity(0.5), // error-container
        ),
        _buildKPICard(
          context,
          title: 'Nuevos Negocios (Mes)',
          value: compania.newBusiness.toString().padLeft(2, '0'),
          change: compania.newBusinessChange,
          icon: Icons.add_business,
          color: const Color(0xFF006C49), // secondary
          bgColor: const Color(0xFF6CF8BB).withOpacity(0.3), // secondary-container approx
        ),
      ],
    );
  }

  Widget _buildKPICard(
    BuildContext context, {
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFC2C6D6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: bgColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      Text(
                        change,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0B1C30), // on-surface
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF424754), // on-surface-variant
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsAndDetails(BuildContext context, bool isDesktop) {
    return Flex(
      direction: isDesktop ? Axis.horizontal : Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isDesktop) Expanded(child: _buildChartBox(context)) else _buildChartBox(context),
        SizedBox(height: isDesktop ? 0 : 24, width: isDesktop ? 24 : 0),
        if (isDesktop) Expanded(child: _buildRenewalBox(context)) else _buildRenewalBox(context),
      ],
    );
  }

  Widget _buildChartBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC2C6D6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribución por Ramo',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0B1C30),
            ),
          ),
          const SizedBox(height: 24),
          ...compania.branches.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildProgressRow(b.name, '${b.policies} Pólizas', b.percentage, b.color),
              )),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Generando informe completo...'),
                    backgroundColor: compania.primaryColor,
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: compania.primaryColor,
                side: BorderSide(color: compania.primaryColor),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Ver Informe Completo', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRenewalBox(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC2C6D6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Próximas Renovaciones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0B1C30),
            ),
          ),
          const SizedBox(height: 16),
          ...compania.renewals.map((r) => _buildRenewalItem(r.clientName, r.policyNumber, r.dateString, r.bgColor, r.textColor)),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, String value, double percentage, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0B1C30))),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: percentage,
          backgroundColor: const Color(0xFFE5EEFF),
          color: color,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _buildRenewalItem(String name, String policy, String dateStr, Color dateBg, Color dateColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFD3E4FE), // surface-variant
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Color(0xFF0058BE)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0B1C30))),
                  Text(policy, style: const TextStyle(fontSize: 14, color: Color(0xFF424754))),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: dateBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              dateStr,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: dateColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF), // surface-container-low
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceAround,
        runSpacing: 24,
        children: [
          _buildStatColumn('Crecimiento Anual', compania.annualGrowth, const Color(0xFF006C49)),
          _buildDivider(),
          _buildStatColumn('Comisiones Pendientes', compania.pendingCommissions, const Color(0xFF0058BE)),
          _buildDivider(),
          _buildStatColumn('Siniestros Abiertos', compania.openClaims, const Color(0xFFBA1A1A)),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF424754),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 32,
      color: const Color(0xFFC2C6D6),
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
