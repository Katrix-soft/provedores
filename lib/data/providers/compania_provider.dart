import 'package:flutter/material.dart';
import '../models/compania_model.dart';

class CompaniaProvider extends ChangeNotifier {
  final List<Compania> _companias = [
    const Compania(
      id: '1',
      name: 'Allianz',
      logoUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDDEGJG0jxqzrxBqvPB0bs1awtSuZtXDYGPuPdHRv6MUevhJ3OChTXutYt__NMH275ey5YkjKNI2GwbuSuXzZRYtWiemhC-YWxKT8-4cGvJPAQuQJmtF3-8CKMJBHsPrsLheVRIiyufm27OR0754BKluI1-NYVSLuFuKi0ak3FaFNtL2fo4x-bKECKb-iF58YOwhYr66cwHaEkq33iLxVNv9MVdrIkHj1eponUZW3zZlTFsfjCibXNAmj2iqdsd9t2j4eunJhaGBpF4',
      primaryColor: Color(0xFF0058BE), // primary
      icon: Icons.business,
      totalPolicies: 42,
      managedPremium: 3.2, // in millions
      retentionRate: 92.0,
      retentionChange: '+2.4%',
      lossRatio: 45.0,
      lossRatioChange: '-5.1%',
      newBusiness: 8,
      newBusinessChange: 'Target Met',
      branches: [
        RamoDistribution(name: 'Automotor', policies: 25, percentage: 0.60, color: Color(0xFF0058BE)),
        RamoDistribution(name: 'Hogar / Combinado Familiar', policies: 10, percentage: 0.24, color: Color(0xFF006C49)),
        RamoDistribution(name: 'Vida Individual', policies: 7, percentage: 0.16, color: Color(0xFF4648D4)),
      ],
      renewals: [
        Renovacion(clientName: 'Eduardo Martínez', policyNumber: 'Pol: 0092-334912', dateString: '12 JUN', bgColor: Color(0xFF6CF8BB), textColor: Color(0xFF00714D)),
        Renovacion(clientName: 'Logística Sur S.A.', policyNumber: 'Pol: 0092-441029', dateString: '15 JUN', bgColor: Color(0xFF6CF8BB), textColor: Color(0xFF00714D)),
        Renovacion(clientName: 'María Belén Ortega', policyNumber: 'Pol: 0092-882190', dateString: 'HOY', bgColor: Color(0xFFFFDAD6), textColor: Color(0xFF93000A)),
        Renovacion(clientName: 'Carlos D\'Amico', policyNumber: 'Pol: 0092-110022', dateString: '18 JUN', bgColor: Color(0xFF6CF8BB), textColor: Color(0xFF00714D)),
        Renovacion(clientName: 'Inmobiliaria Central', policyNumber: 'Pol: 0092-557612', dateString: '20 JUN', bgColor: Color(0xFF6CF8BB), textColor: Color(0xFF00714D)),
      ],
      annualGrowth: '+12.5%',
      pendingCommissions: '\$124.500',
      openClaims: '4',
    ),
    const Compania(
      id: '2',
      name: 'Mapfre',
      logoUrl: 'https://placehold.co/200x200/BA1A1A/FFFFFF/png?text=MAPFRE',
      primaryColor: Color(0xFFBA1A1A), // Error color for Mapfre
      icon: Icons.business,
      totalPolicies: 28,
      managedPremium: 1.8,
      retentionRate: 88.5,
      retentionChange: '-1.5% vs last year',
      lossRatio: 72.0,
      lossRatioChange: '+2.0% increase',
      newBusiness: 5,
      newBusinessChange: 'Below Target',
      branches: [
        RamoDistribution(name: 'Automotor', policies: 15, percentage: 0.53, color: Color(0xFFBA1A1A)),
        RamoDistribution(name: 'Comercio', policies: 8, percentage: 0.29, color: Color(0xFF006C49)),
        RamoDistribution(name: 'Transporte', policies: 5, percentage: 0.18, color: Color(0xFF4648D4)),
      ],
      renewals: [
        Renovacion(clientName: 'Transportes Rápidos', policyNumber: 'Pol: 1042-555123', dateString: '14 JUN', bgColor: Color(0xFF6CF8BB), textColor: Color(0xFF00714D)),
        Renovacion(clientName: 'Juan Pérez', policyNumber: 'Pol: 1042-888999', dateString: 'HOY', bgColor: Color(0xFFFFDAD6), textColor: Color(0xFF93000A)),
      ],
      annualGrowth: '+5.2%',
      pendingCommissions: '\$82,500',
      openClaims: '5 Activos',
    ),
    const Compania(
      id: '3',
      name: 'Zurich',
      logoUrl: 'https://placehold.co/200x200/006C49/FFFFFF/png?text=ZURICH',
      primaryColor: Color(0xFF006C49), // secondary
      icon: Icons.business,
      totalPolicies: 15,
      managedPremium: 4.5,
      retentionRate: 97.0,
      retentionChange: '+4.0% vs last year',
      lossRatio: 55.2,
      lossRatioChange: '-5.0% improvement',
      newBusiness: 12,
      newBusinessChange: 'Target Exceeded',
      branches: [
        RamoDistribution(name: 'Integral de Comercio', policies: 10, percentage: 0.66, color: Color(0xFF006C49)),
        RamoDistribution(name: 'Caución', policies: 5, percentage: 0.34, color: Color(0xFF0058BE)),
      ],
      renewals: [
        Renovacion(clientName: 'Constructora Beta', policyNumber: 'Pol: 9982-111222', dateString: '25 JUN', bgColor: Color(0xFF6CF8BB), textColor: Color(0xFF00714D)),
      ],
      annualGrowth: '+22.1%',
      pendingCommissions: '\$320,000',
      openClaims: '3 Activos',
    ),
  ];

  List<Compania> get companias => _companias;

  Compania? getCompaniaById(String id) {
    try {
      return _companias.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
