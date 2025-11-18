/// Airline Compliance Service
/// Checks luggage compliance against airline baggage rules
class AirlineComplianceService {
  /// Get airline baggage rules by airline code
  static AirlineBaggageRules? getAirlineRules(String? airlineCode) {
    if (airlineCode == null || airlineCode.isEmpty) {
      return _getDefaultRules();
    }

    return _airlineRulesDatabase[airlineCode.toUpperCase()] ?? _getDefaultRules();
  }

  /// Check luggage compliance
  static ComplianceResult checkCompliance({
    required Map<String, dynamic> luggage,
    required String? airlineCode,
    List<Map<String, dynamic>> packingItems = const [],
  }) {
    final rules = getAirlineRules(airlineCode);
    if (rules == null) {
      return ComplianceResult(
        isCompliant: true,
        violations: [],
        warnings: [],
      );
    }

    final violations = <ComplianceViolation>[];
    final warnings = <ComplianceWarning>[];

    // Check dimensions
    final dims = luggage['dimensions'] as Map<String, dynamic>?;
    if (dims != null) {
      final length = dims['length'] as double;
      final width = dims['width'] as double;
      final height = dims['height'] as double;

      // Total linear dimensions (L + W + H)
      final totalLinear = length + width + height;

      if (luggage['type'] == 'carry-on') {
        // Check individual dimensions
        if (length > rules.carryOnMaxLength ||
            width > rules.carryOnMaxWidth ||
            height > rules.carryOnMaxHeight) {
          violations.add(ComplianceViolation(
            type: ViolationType.sizeDimensions,
            message: 'Carry-on exceeds size limits',
            detail: 'Max: ${rules.carryOnMaxLength}×${rules.carryOnMaxWidth}×${rules.carryOnMaxHeight} cm\n'
                'Your bag: ${length}×${width}×${height} cm',
            severity: ViolationSeverity.critical,
          ));
        } else if (length > rules.carryOnMaxLength * 0.9 ||
            width > rules.carryOnMaxWidth * 0.9 ||
            height > rules.carryOnMaxHeight * 0.9) {
          warnings.add(ComplianceWarning(
            message: 'Carry-on close to size limit',
            recommendation: 'Consider a slightly smaller bag for easier overhead storage',
          ));
        }
      } else if (luggage['type'] == 'checked') {
        if (totalLinear > rules.checkedMaxLinear) {
          violations.add(ComplianceViolation(
            type: ViolationType.sizeDimensions,
            message: 'Checked bag exceeds linear dimensions',
            detail: 'Max total: ${rules.checkedMaxLinear} cm (L+W+H)\n'
                'Your bag: $totalLinear cm',
            severity: ViolationSeverity.critical,
          ));
        }
      }
    }

    // Check weight
    final weight = luggage['weight'] as double?;
    if (weight != null) {
      if (luggage['type'] == 'carry-on' && weight > rules.carryOnMaxWeight) {
        violations.add(ComplianceViolation(
          type: ViolationType.weight,
          message: 'Carry-on exceeds weight limit',
          detail: 'Max: ${rules.carryOnMaxWeight} kg\nYour bag: $weight kg',
          severity: ViolationSeverity.critical,
        ));
      } else if (luggage['type'] == 'checked' && weight > rules.checkedMaxWeight) {
        violations.add(ComplianceViolation(
          type: ViolationType.weight,
          message: 'Checked bag exceeds weight limit',
          detail: 'Max: ${rules.checkedMaxWeight} kg\nYour bag: $weight kg',
          severity: ViolationSeverity.critical,
        ));
      } else if (luggage['type'] == 'carry-on' && weight > rules.carryOnMaxWeight * 0.8) {
        warnings.add(ComplianceWarning(
          message: 'Carry-on approaching weight limit',
          recommendation: 'Try to keep some room for duty-free items',
        ));
      }
    }

    // Check prohibited items
    for (var item in packingItems) {
      final itemName = (item['name'] as String).toLowerCase();

      for (var prohibited in rules.prohibitedItems) {
        if (itemName.contains(prohibited.toLowerCase())) {
          violations.add(ComplianceViolation(
            type: ViolationType.prohibitedItem,
            message: 'Prohibited item detected',
            detail: '${item['name']} is not allowed in ${luggage['type'] == 'carry-on' ? 'carry-on' : 'checked'} luggage',
            severity: ViolationSeverity.critical,
          ));
        }
      }

      // Check liquid restrictions for carry-on
      if (luggage['type'] == 'carry-on') {
        for (var liquid in rules.liquidRestrictions) {
          if (itemName.contains(liquid.toLowerCase())) {
            warnings.add(ComplianceWarning(
              message: 'Liquid restriction applies',
              recommendation: '${item['name']} must be in container ≤ 100ml and in clear plastic bag',
            ));
          }
        }
      }
    }

    // Battery warnings
    final hasBatteries = packingItems.any((item) =>
        (item['name'] as String).toLowerCase().contains('battery') ||
        (item['name'] as String).toLowerCase().contains('power bank'));

    if (hasBatteries && luggage['type'] == 'checked') {
      violations.add(ComplianceViolation(
        type: ViolationType.prohibitedItem,
        message: 'Batteries not allowed in checked luggage',
        detail: 'Lithium batteries and power banks must be in carry-on',
        severity: ViolationSeverity.critical,
      ));
    }

    return ComplianceResult(
      isCompliant: violations.isEmpty,
      violations: violations,
      warnings: warnings,
    );
  }

  static AirlineBaggageRules _getDefaultRules() {
    return AirlineBaggageRules(
      airlineCode: 'DEFAULT',
      airlineName: 'Standard Airline',
      carryOnMaxLength: 55,
      carryOnMaxWidth: 40,
      carryOnMaxHeight: 23,
      carryOnMaxWeight: 7,
      checkedMaxWeight: 23,
      checkedMaxLinear: 158,
      prohibitedItems: _defaultProhibitedItems,
      liquidRestrictions: _defaultLiquidItems,
    );
  }

  static final List<String> _defaultProhibitedItems = [
    'knife',
    'scissors',
    'lighter',
    'matches',
    'explosive',
    'firearm',
    'weapon',
  ];

  static final List<String> _defaultLiquidItems = [
    'shampoo',
    'conditioner',
    'lotion',
    'perfume',
    'cologne',
    'toothpaste',
    'gel',
    'cream',
  ];

  /// Mock airline rules database
  static final Map<String, AirlineBaggageRules> _airlineRulesDatabase = {
    'AA': AirlineBaggageRules(
      airlineCode: 'AA',
      airlineName: 'American Airlines',
      carryOnMaxLength: 56,
      carryOnMaxWidth: 36,
      carryOnMaxHeight: 23,
      carryOnMaxWeight: 7,
      checkedMaxWeight: 23,
      checkedMaxLinear: 158,
      prohibitedItems: _defaultProhibitedItems,
      liquidRestrictions: _defaultLiquidItems,
    ),
    'UA': AirlineBaggageRules(
      airlineCode: 'UA',
      airlineName: 'United Airlines',
      carryOnMaxLength: 56,
      carryOnMaxWidth: 35,
      carryOnMaxHeight: 22,
      carryOnMaxWeight: 7,
      checkedMaxWeight: 23,
      checkedMaxLinear: 158,
      prohibitedItems: _defaultProhibitedItems,
      liquidRestrictions: _defaultLiquidItems,
    ),
    'DL': AirlineBaggageRules(
      airlineCode: 'DL',
      airlineName: 'Delta Air Lines',
      carryOnMaxLength: 56,
      carryOnMaxWidth: 35,
      carryOnMaxHeight: 23,
      carryOnMaxWeight: 7,
      checkedMaxWeight: 23,
      checkedMaxLinear: 157,
      prohibitedItems: _defaultProhibitedItems,
      liquidRestrictions: _defaultLiquidItems,
    ),
    'BA': AirlineBaggageRules(
      airlineCode: 'BA',
      airlineName: 'British Airways',
      carryOnMaxLength: 56,
      carryOnMaxWidth: 45,
      carryOnMaxHeight: 25,
      carryOnMaxWeight: 23, // BA allows heavier carry-on
      checkedMaxWeight: 23,
      checkedMaxLinear: 158,
      prohibitedItems: _defaultProhibitedItems,
      liquidRestrictions: _defaultLiquidItems,
    ),
    'LH': AirlineBaggageRules(
      airlineCode: 'LH',
      airlineName: 'Lufthansa',
      carryOnMaxLength: 55,
      carryOnMaxWidth: 40,
      carryOnMaxHeight: 23,
      carryOnMaxWeight: 8,
      checkedMaxWeight: 23,
      checkedMaxLinear: 158,
      prohibitedItems: _defaultProhibitedItems,
      liquidRestrictions: _defaultLiquidItems,
    ),
    'AF': AirlineBaggageRules(
      airlineCode: 'AF',
      airlineName: 'Air France',
      carryOnMaxLength: 55,
      carryOnMaxWidth: 35,
      carryOnMaxHeight: 25,
      carryOnMaxWeight: 12, // AF allows heavier carry-on
      checkedMaxWeight: 23,
      checkedMaxLinear: 158,
      prohibitedItems: _defaultProhibitedItems,
      liquidRestrictions: _defaultLiquidItems,
    ),
  };
}

// Models
class AirlineBaggageRules {
  final String airlineCode;
  final String airlineName;
  final double carryOnMaxLength; // cm
  final double carryOnMaxWidth; // cm
  final double carryOnMaxHeight; // cm
  final double carryOnMaxWeight; // kg
  final double checkedMaxWeight; // kg
  final double checkedMaxLinear; // cm (L + W + H)
  final List<String> prohibitedItems;
  final List<String> liquidRestrictions;

  AirlineBaggageRules({
    required this.airlineCode,
    required this.airlineName,
    required this.carryOnMaxLength,
    required this.carryOnMaxWidth,
    required this.carryOnMaxHeight,
    required this.carryOnMaxWeight,
    required this.checkedMaxWeight,
    required this.checkedMaxLinear,
    required this.prohibitedItems,
    required this.liquidRestrictions,
  });
}

class ComplianceResult {
  final bool isCompliant;
  final List<ComplianceViolation> violations;
  final List<ComplianceWarning> warnings;

  ComplianceResult({
    required this.isCompliant,
    required this.violations,
    required this.warnings,
  });

  bool get hasIssues => violations.isNotEmpty || warnings.isNotEmpty;
  int get issueCount => violations.length + warnings.length;
}

class ComplianceViolation {
  final ViolationType type;
  final String message;
  final String detail;
  final ViolationSeverity severity;

  ComplianceViolation({
    required this.type,
    required this.message,
    required this.detail,
    required this.severity,
  });
}

class ComplianceWarning {
  final String message;
  final String recommendation;

  ComplianceWarning({
    required this.message,
    required this.recommendation,
  });
}

enum ViolationType {
  sizeDimensions,
  weight,
  prohibitedItem,
  liquidRestriction,
}

enum ViolationSeverity {
  critical, // Will not be allowed on flight
  warning, // May cause issues
  info, // Informational only
}
