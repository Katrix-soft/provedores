import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/dashboard_home_view.dart';
import 'views/cobranzas_view.dart';
import 'views/clientes_view.dart';
import 'views/companias_view.dart';
import 'perfil_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String _username = 'Nicolás';
  String _role = 'agente';
  int _userId = 28491;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'Nicolás';
      _role = prefs.getString('role') ?? 'agente';
      _userId = prefs.getInt('user_id') ?? 28491;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      bottomNavigationBar: isDesktop ? null : _buildBottomNavBar(),
      body: Row(
        children: [
          if (isDesktop) _buildSideMenu(context),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      DashboardHomeView(username: _username),
                      const CobranzasView(),
                      const ClientesView(),
                      const CompaniasView(),
                      PerfilScreen(username: _username, role: _role, userId: _userId),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Métricas'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Cobros'),
        BottomNavigationBarItem(icon: Icon(Icons.person_search), label: 'Clientes'),
        BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Compañías'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }

  Widget _buildSideMenu(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'Seguros Globales',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF6FFBBE), width: 2),
                    image: const DecorationImage(
                      image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDzNU6AwjOUme4uTYL9zshWPM1P1JOdiffDFW7rLQ0z8I1mQHYlcGgvTesz1EyndQFrCG1oKAMcoqh8bEcB9h6fDDdc0Fmj8BSI2Xx3q64pxC0OxPNemeMctL3v2dpVzdnbeK6fX_5DS-NRn6zzQdwquXeVTe-IOvmGwWYpKQpxXFx5S6k9dBLitOoG_WCJWGD0uWeOPv1yF_HQjv1iIVnu-HOK7zGr1JFyJTLT6JTOfOa73ZAZoRnkcprY7-U1cwMUiEeP2q6k_BKh'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _role == 'admin' ? 'Administrador' : 'Agente Profesional',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF006C49), // secondary-fixed like in HTML
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _username,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: $_userId',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.outlineVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildDrawerItem(context, Icons.dashboard, 'Dashboard', 0),
          _buildDrawerItem(context, Icons.payments, 'Cobranzas', 1),
          _buildDrawerItem(context, Icons.groups, 'Clientes', 2),
          _buildDrawerItem(context, Icons.business, 'Compañías', 3),
          _buildDrawerItem(context, Icons.person, 'Perfil', 4),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, int index) {
    final isSelected = _selectedIndex == index;
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Material(
        color: isSelected ? theme.colorScheme.primaryContainer : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () => setState(() => _selectedIndex = index),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    String getTitle(int index) {
      switch (index) {
        case 0: return 'Métricas de Gestión';
        case 1: return 'Cobranzas';
        case 2: return 'Gestión de Clientes';
        case 3: return 'Compañías';
        case 4: return 'Mi Perfil';
        default: return 'Assurance Nexus';
      }
    }

    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.5)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            getTitle(_selectedIndex),
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
          Row(
            children: [
              if (MediaQuery.of(context).size.width >= 768)
                IconButton(
                  icon: const Icon(Icons.search),
                  color: theme.colorScheme.onSurfaceVariant,
                  onPressed: () {},
                ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  setState(() => _selectedIndex = 4);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFD8E2FF), width: 2),
                    image: const DecorationImage(
                      image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCTIabKB45fJfFZT8sg1aLxduEgN7AhCOFzIsvmDSkF1oQKBmdkCcCBoTSyCSChn6hodGbZI9ruZjissrJ5QsF3IDVRtjA6J_W2g7JLX0xFKsM1ikBVlcQ9r38sAYjxHsXHIZPTgie5K_XSZduWWYNgACxqSIw2gLDCzotWC2Dnob-KctR1SKP16Bl51hNH5aWcclyiekEm3v5yGCDSQ9gi7Dg_7O1eT0OBqbZcPDCORCLDN0MRj7JEYCCNBeurMU-BOkLdAi8BUPh0'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _getViewForIndex(int index) {
    switch (index) {
      case 0:
        return DashboardHomeView(username: _username);
      case 1:
        return const CobranzasView();
      case 2:
        return const ClientesView();
      case 3:
        return const CompaniasView();
      case 4:
        return PerfilScreen(username: _username, role: _role, userId: _userId);
      default:
        return DashboardHomeView(username: _username);
    }
  }
}
