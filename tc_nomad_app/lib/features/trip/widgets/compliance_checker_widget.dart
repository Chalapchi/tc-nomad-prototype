import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../services/airline_compliance_service.dart';

/// Compliance Checker Widget
/// Displays airline baggage compliance status with violations and warnings
class ComplianceCheckerWidget extends StatelessWidget {
  final Map<String, dynamic> luggage;
  final String? airlineCode;
  final List<Map<String, dynamic>> packingItems;
  final bool showDetails;

  const ComplianceCheckerWidget({
    super.key,
    required this.luggage,
    this.airlineCode,
    this.packingItems = const [],
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    final result = AirlineComplianceService.checkCompliance(
      luggage: luggage,
      airlineCode: airlineCode,
      packingItems: packingItems,
    );

    final rules = AirlineComplianceService.getAirlineRules(airlineCode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with airline info
        Row(
          children: [
            const Icon(Icons.flight_takeoff, color: AppColors.primary, size: 24),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Airline Compliance', style: AppTextStyles.headlineSmall),
                  if (rules != null)
                    Text(
                      rules.airlineName,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),

        // Status Card
        _buildStatusCard(result),

        // Violations
        if (result.violations.isNotEmpty && showDetails) ...[
          const SizedBox(height: AppConstants.spacingLg),
          Text('Critical Issues', style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppConstants.spacingMd),
          ...result.violations.map((violation) => _buildViolationCard(violation)),
        ],

        // Warnings
        if (result.warnings.isNotEmpty && showDetails) ...[
          const SizedBox(height: AppConstants.spacingLg),
          Text('Recommendations', style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppConstants.spacingMd),
          ...result.warnings.map((warning) => _buildWarningCard(warning)),
        ],

        // Airline Rules Summary
        if (showDetails && rules != null) ...[
          const SizedBox(height: AppConstants.spacingLg),
          _buildRulesSummary(rules),
        ],
      ],
    );
  }

  Widget _buildStatusCard(ComplianceResult result) {
    final Color statusColor;
    final IconData statusIcon;
    final String statusText;

    if (result.isCompliant && result.warnings.isEmpty) {
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle;
      statusText = 'Fully Compliant';
    } else if (result.isCompliant && result.warnings.isNotEmpty) {
      statusColor = AppColors.warning;
      statusIcon = Icons.warning_amber;
      statusText = 'Compliant with Warnings';
    } else {
      statusColor = AppColors.error;
      statusIcon = Icons.cancel;
      statusText = 'Not Compliant';
    }

    return GlassCard(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              statusColor.withOpacity(0.1),
              statusColor.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(color: statusColor, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
              ),
              child: Icon(statusIcon, color: Colors.white, size: 32),
            ),
            const SizedBox(width: AppConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusText,
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (result.hasIssues)
                    Text(
                      '${result.violations.length} violation${result.violations.length != 1 ? 's' : ''}, '
                      '${result.warnings.length} warning${result.warnings.length != 1 ? 's' : ''}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    )
                  else
                    Text(
                      'Your luggage meets all airline requirements',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
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

  Widget _buildViolationCard(ComplianceViolation violation) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  violation.message,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  violation.detail,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningCard(ComplianceWarning warning) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warning,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  warning.message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  warning.recommendation,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRulesSummary(AirlineBaggageRules rules) {
    return GlassCard(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.rule, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text('Baggage Rules', style: AppTextStyles.labelLarge),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMd),
            _buildRuleItem(
              'Carry-On Size',
              '${rules.carryOnMaxLength}×${rules.carryOnMaxWidth}×${rules.carryOnMaxHeight} cm',
              Icons.straighten,
            ),
            _buildRuleItem(
              'Carry-On Weight',
              '${rules.carryOnMaxWeight} kg',
              Icons.fitness_center,
            ),
            _buildRuleItem(
              'Checked Bag Weight',
              '${rules.checkedMaxWeight} kg',
              Icons.luggage,
            ),
            _buildRuleItem(
              'Checked Bag Linear',
              '${rules.checkedMaxLinear} cm (L+W+H)',
              Icons.straighten,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact Compliance Badge
/// Small status indicator for use in trip cards
class ComplianceBadge extends StatelessWidget {
  final Map<String, dynamic> luggage;
  final String? airlineCode;

  const ComplianceBadge({
    super.key,
    required this.luggage,
    this.airlineCode,
  });

  @override
  Widget build(BuildContext context) {
    final result = AirlineComplianceService.checkCompliance(
      luggage: luggage,
      airlineCode: airlineCode,
    );

    final Color badgeColor;
    final IconData badgeIcon;
    final String badgeText;

    if (result.isCompliant && result.warnings.isEmpty) {
      badgeColor = AppColors.success;
      badgeIcon = Icons.check_circle;
      badgeText = 'Compliant';
    } else if (result.isCompliant) {
      badgeColor = AppColors.warning;
      badgeIcon = Icons.warning_amber;
      badgeText = '${result.warnings.length} Warning${result.warnings.length != 1 ? 's' : ''}';
    } else {
      badgeColor = AppColors.error;
      badgeIcon = Icons.error;
      badgeText = '${result.violations.length} Issue${result.violations.length != 1 ? 's' : ''}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, size: 16, color: badgeColor),
          const SizedBox(width: 6),
          Text(
            badgeText,
            style: AppTextStyles.labelSmall.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
