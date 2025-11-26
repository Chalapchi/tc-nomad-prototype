import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/glass_card.dart';

/// Paywall Screen
/// Shows subscription options and Free vs Pro comparison
class PaywallScreen extends StatefulWidget {
  final bool canDismiss; // Whether user can skip (for initial view)

  const PaywallScreen({
    super.key,
    this.canDismiss = true,
  });

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool _isAnnual = true; // Default to annual (better value)
  bool _isLoading = false;

  // Mock usage data (should come from state management)
  final int _tripsUsed = 1;
  final int _tripsLimit = 1; // Free tier limit
  final int _aiGenerationsUsed = 2;
  final int _aiGenerationsLimit = 3; // Free tier limit

  final List<SubscriptionFeature> _features = [
    SubscriptionFeature(
      icon: Icons.flight_takeoff,
      title: 'Unlimited Trips',
      freeValue: '1 trip only',
      proValue: 'Unlimited',
      isHighlight: true,
    ),
    SubscriptionFeature(
      icon: Icons.auto_awesome,
      title: 'AI Packing Lists',
      freeValue: '3 generations',
      proValue: 'Unlimited',
      isHighlight: true,
    ),
    SubscriptionFeature(
      icon: Icons.cloud,
      title: 'Weather Forecasts',
      freeValue: 'Basic',
      proValue: 'Extended 14-day',
    ),
    SubscriptionFeature(
      icon: Icons.layers,
      title: 'Visual Packing Guide',
      freeValue: 'Basic',
      proValue: 'Advanced with layers',
    ),
    SubscriptionFeature(
      icon: Icons.luggage,
      title: 'Luggage Profiles',
      freeValue: '1 profile',
      proValue: 'Unlimited',
    ),
    SubscriptionFeature(
      icon: Icons.flight,
      title: 'Airline Compliance',
      freeValue: 'Limited airlines',
      proValue: '100+ airlines',
    ),
    SubscriptionFeature(
      icon: Icons.sync,
      title: 'Cloud Sync',
      freeValue: '✗',
      proValue: '✓ All devices',
    ),
    SubscriptionFeature(
      icon: Icons.support_agent,
      title: 'Priority Support',
      freeValue: '✗',
      proValue: '✓ 24/7 support',
    ),
  ];

  void _handleSubscribe() async {
    setState(() => _isLoading = true);

    // Simulate subscription process
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (!mounted) return;

    // TODO: Implement actual in-app purchase
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Subscription activated! (Mock - integrate with in-app purchase)',
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );

    // Navigate back
    Navigator.pop(context, true); // true = subscribed
  }

  void _handleRestore() async {
    setState(() => _isLoading = true);

    // Simulate restore process
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No previous purchases found'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade to Pro'),
        automaticallyImplyLeading: widget.canDismiss,
        actions: [
          if (widget.canDismiss)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Maybe Later',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.spacingXl),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    Text(
                      'Unlock Premium Features',
                      style: AppTextStyles.displaySmall.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    Text(
                      'Get unlimited trips and AI-powered packing lists',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Usage Stats (if free tier)
                  if (_tripsUsed >= _tripsLimit || _aiGenerationsUsed >= _aiGenerationsLimit)
                    _buildUsageWarning(),

                  const SizedBox(height: AppConstants.spacingXl),

                  // Plan Toggle
                  _buildPlanToggle(),

                  const SizedBox(height: AppConstants.spacingXl),

                  // Features Comparison
                  Text(
                    'What You Get with Pro',
                    style: AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: AppConstants.spacingMd),
                  ..._features.map((feature) => _buildFeatureRow(feature)),

                  const SizedBox(height: AppConstants.spacingXl),

                  // Subscribe Button
                  _buildSubscribeButton(),

                  const SizedBox(height: AppConstants.spacingMd),

                  // Restore Button
                  Center(
                    child: TextButton(
                      onPressed: _isLoading ? null : _handleRestore,
                      child: Text(
                        'Restore Purchase',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingMd),

                  // Terms
                  Text(
                    'Subscription auto-renews. Cancel anytime in your account settings. '
                    'By subscribing, you agree to our Terms of Service and Privacy Policy.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageWarning() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.warning),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber, color: AppColors.warning),
              const SizedBox(width: 8),
              Text(
                'Usage Limit Reached',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingSm),
          _buildUsageMeter('Trips', _tripsUsed, _tripsLimit),
          const SizedBox(height: AppConstants.spacingSm),
          _buildUsageMeter('AI Generations', _aiGenerationsUsed, _aiGenerationsLimit),
        ],
      ),
    );
  }

  Widget _buildUsageMeter(String label, int used, int limit) {
    final percentage = (used / limit).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.bodySmall),
            Text(
              '$used / $limit',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.background,
            valueColor: AlwaysStoppedAnimation<Color>(
              percentage >= 1.0 ? AppColors.error : AppColors.warning,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildPlanToggle() {
    return GlassCard(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          children: [
            // Toggle
            Row(
              children: [
                Expanded(
                  child: _buildPlanOption(
                    isSelected: !_isAnnual,
                    title: 'Monthly',
                    price: '\$1.99',
                    period: '/month',
                    onTap: () => setState(() => _isAnnual = false),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: _buildPlanOption(
                    isSelected: _isAnnual,
                    title: 'Annual',
                    price: '\$9.99',
                    period: '/year',
                    badge: 'SAVE 58%',
                    onTap: () => setState(() => _isAnnual = true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMd),
            // Savings info
            if (_isAnnual)
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingSm),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.savings, color: AppColors.success, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'Save \$13.89 per year!',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
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

  Widget _buildPlanOption({
    required bool isSelected,
    required String title,
    required String price,
    required String period,
    String? badge,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          color: isSelected ? null : AppColors.background,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      period,
                      style: AppTextStyles.caption.copyWith(
                        color: isSelected
                            ? Colors.white.withOpacity(0.8)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (badge != null)
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(SubscriptionFeature feature) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: feature.isHighlight
            ? AppColors.primary.withOpacity(0.05)
            : AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: feature.isHighlight
              ? AppColors.primary.withOpacity(0.3)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(feature.icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(feature.title, style: AppTextStyles.bodyMedium),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'Free: ',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    Text(
                      feature.freeValue,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              feature.proValue,
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton() {
    return GradientButton(
      text: _isLoading
          ? 'Processing...'
          : 'Subscribe ${_isAnnual ? 'for \$9.99/year' : 'for \$1.99/month'}',
      onPressed: _isLoading ? () {} : _handleSubscribe,
      icon: _isLoading ? null : Icons.stars,
    );
  }
}

// Model
class SubscriptionFeature {
  final IconData icon;
  final String title;
  final String freeValue;
  final String proValue;
  final bool isHighlight;

  SubscriptionFeature({
    required this.icon,
    required this.title,
    required this.freeValue,
    required this.proValue,
    this.isHighlight = false,
  });
}
