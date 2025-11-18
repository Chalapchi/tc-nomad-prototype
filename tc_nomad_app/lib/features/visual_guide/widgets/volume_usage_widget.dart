import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';

/// Volume Usage Widget
/// Displays luggage capacity usage with warnings
class VolumeUsageWidget extends StatelessWidget {
  final double usedVolume;
  final double totalVolume;
  final String compartmentName;

  const VolumeUsageWidget({
    super.key,
    required this.usedVolume,
    required this.totalVolume,
    required this.compartmentName,
  });

  double get _usagePercentage => (usedVolume / totalVolume * 100).clamp(0.0, 100.0);
  bool get _isWarning => _usagePercentage >= 80;
  bool get _isOverpacked => _usagePercentage >= 100;
  bool get _isNearCapacity => _usagePercentage >= 90;

  Color get _statusColor {
    if (_isOverpacked) return AppColors.error;
    if (_isNearCapacity) return AppColors.warning;
    if (_isWarning) return Colors.orange;
    return AppColors.success;
  }

  IconData get _statusIcon {
    if (_isOverpacked) return Icons.warning;
    if (_isNearCapacity) return Icons.info_outline;
    if (_isWarning) return Icons.trending_up;
    return Icons.check_circle;
  }

  String get _statusMessage {
    if (_isOverpacked) return 'Overpacked! Remove some items';
    if (_isNearCapacity) return 'Almost full - pack carefully';
    if (_isWarning) return 'Getting full';
    return 'Good capacity';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: _isWarning ? _statusColor : AppColors.border,
          width: _isWarning ? 2 : 1,
        ),
        boxShadow: _isWarning
            ? [
                BoxShadow(
                  color: _statusColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(_statusIcon, color: _statusColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Volume Usage - $compartmentName',
                  style: AppTextStyles.labelLarge,
                ),
              ),
              Text(
                '${_usagePercentage.toStringAsFixed(0)}%',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: _statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // Progress Bar
          Stack(
            children: [
              // Background
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              // Fill
              FractionallySizedBox(
                widthFactor: (_usagePercentage / 100).clamp(0.0, 1.0),
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    gradient: _isWarning
                        ? LinearGradient(
                            colors: [_statusColor, _statusColor.withOpacity(0.7)],
                          )
                        : AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              // Text overlay
              SizedBox(
                height: 24,
                child: Center(
                  child: Text(
                    '${usedVolume.toStringAsFixed(1)}L / ${totalVolume.toStringAsFixed(1)}L',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: _usagePercentage > 50 ? Colors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),

          // Status Message
          if (_isWarning)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingSm,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_statusIcon, color: _statusColor, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    _statusMessage,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: _statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          // Capacity Tips
          if (_isNearCapacity || _isOverpacked) ...[
            const SizedBox(height: AppConstants.spacingMd),
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingSm),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                border: Border.all(color: AppColors.info.withOpacity(0.2)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb_outline, size: 16, color: AppColors.info),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _isOverpacked
                          ? 'Try using compression bags or moving items to other compartments'
                          : 'Use rolling technique to maximize space efficiency',
                      style: AppTextStyles.caption.copyWith(color: AppColors.info),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Volume Calculator Utility
class VolumeCalculator {
  /// Estimate item volume in liters based on category and quantity
  static double estimateItemVolume(String itemName, int quantity) {
    // Volume estimates in liters
    final Map<String, double> volumeEstimates = {
      // Clothing (rolled/folded)
      'shirt': 0.5,
      't-shirt': 0.3,
      'pants': 0.8,
      'jeans': 1.0,
      'dress': 1.2,
      'jacket': 1.5,
      'sweater': 0.7,
      'underwear': 0.1,
      'socks': 0.05,
      'shoes': 2.0,

      // Toiletries
      'toiletry': 0.3,
      'toothbrush': 0.02,
      'shampoo': 0.2,
      'deodorant': 0.15,

      // Electronics
      'laptop': 1.5,
      'charger': 0.2,
      'power bank': 0.3,
      'phone': 0.15,

      // Documents
      'passport': 0.01,
      'documents': 0.05,

      // Accessories
      'umbrella': 0.4,
      'hat': 0.3,
      'sunglasses': 0.05,

      // Default
      'default': 0.5,
    };

    // Find matching volume estimate
    double baseVolume = volumeEstimates['default']!;
    for (var entry in volumeEstimates.entries) {
      if (itemName.toLowerCase().contains(entry.key)) {
        baseVolume = entry.value;
        break;
      }
    }

    return baseVolume * quantity;
  }

  /// Get luggage capacity based on type
  static double getLuggageCapacity(String luggageType) {
    final Map<String, double> capacities = {
      'carry-on': 40.0,
      'personal item': 20.0,
      'checked bag': 80.0,
      'backpack': 30.0,
      'duffel': 50.0,
      'default': 40.0,
    };

    return capacities[luggageType.toLowerCase()] ?? capacities['default']!;
  }

  /// Get compartment capacity as percentage of total
  static double getCompartmentCapacity(String compartmentId, double totalCapacity) {
    final Map<String, double> percentages = {
      'main': 0.70, // 70% of total
      'front': 0.15, // 15% of total
      'laptop': 0.10, // 10% of total
      'side': 0.05, // 5% of total
    };

    return totalCapacity * (percentages[compartmentId] ?? 0.25);
  }
}
