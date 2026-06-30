import 'package:flutter/material.dart';

class Compania {
  final String id;
  final String name;
  final String logoUrl;
  final Color primaryColor;
  final IconData icon;

  // Hero metrics
  final int totalPolicies;
  final double managedPremium;

  // KPI metrics
  final double retentionRate;
  final String retentionChange;
  final double lossRatio;
  final String lossRatioChange;
  final int newBusiness;
  final String newBusinessChange;

  // Distribution
  final List<RamoDistribution> branches;

  // Renewals
  final List<Renovacion> renewals;

  // Footer Stats
  final String annualGrowth;
  final String pendingCommissions;
  final String openClaims;

  const Compania({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.primaryColor,
    required this.icon,
    required this.totalPolicies,
    required this.managedPremium,
    required this.retentionRate,
    required this.retentionChange,
    required this.lossRatio,
    required this.lossRatioChange,
    required this.newBusiness,
    required this.newBusinessChange,
    required this.branches,
    required this.renewals,
    required this.annualGrowth,
    required this.pendingCommissions,
    required this.openClaims,
  });
}

class RamoDistribution {
  final String name;
  final int policies;
  final double percentage;
  final Color color;

  const RamoDistribution({
    required this.name,
    required this.policies,
    required this.percentage,
    required this.color,
  });
}

class Renovacion {
  final String clientName;
  final String policyNumber;
  final String dateString;
  final Color bgColor;
  final Color textColor;

  const Renovacion({
    required this.clientName,
    required this.policyNumber,
    required this.dateString,
    required this.bgColor,
    required this.textColor,
  });
}
