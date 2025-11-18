import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';

/// Step 3: Luggage Selection
/// Select from saved luggage profiles or create new
class LuggageStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, dynamic> tripData;

  const LuggageStep({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.tripData,
  });

  @override
  State<LuggageStep> createState() => _LuggageStepState();
}

class _LuggageStepState extends State<LuggageStep> {
  String? _selectedLuggageId;

  // Mock luggage data (replace with actual data from provider)
  final List<Map<String, dynamic>> _mockLuggage = [
    {
      'id': '1',
      'name': 'Black Carry-On',
      'emoji': '🧳',
      'specs': '24" × 16" × 10" • 58L capacity',
      'isDefault': true,
    },
    {
      'id': '2',
      'name': 'Personal Backpack',
      'emoji': '🎒',
      'specs': '18" × 13" × 8" • 20L capacity',
      'isDefault': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedLuggageId = widget.tripData['luggageId'];

    // Auto-select first luggage if none selected
    if (_selectedLuggageId == null && _mockLuggage.isNotEmpty) {
      _selectedLuggageId = _mockLuggage.first['id'] as String;
    }
  }

  void _handleNext() {
    if (_selectedLuggageId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select luggage or create a new one'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    widget.tripData['luggageId'] = _selectedLuggageId;
    widget.onNext();
  }

  void _handleAddLuggage() {
    // TODO: Navigate to luggage creation screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Luggage creation will be implemented in next phase'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            children: [
              Text(
                'Choose Your Luggage',
                style: AppTextStyles.headlineLarge,
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Text(
                'Select luggage for this trip',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Luggage List
              ..._mockLuggage.map((luggage) {
                final id = luggage['id'] as String;
                final isSelected = _selectedLuggageId == id;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedLuggageId = id),
                    child: Container(
                      padding: const EdgeInsets.all(AppConstants.spacingMd),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      ),
                      child: Row(
                        children: [
                          // Emoji Icon
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                            ),
                            child: Center(
                              child: Text(
                                luggage['emoji'] as String,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingMd),

                          // Luggage Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      luggage['name'] as String,
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    if (luggage['isDefault'] as bool) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.success.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'DEFAULT',
                                          style: AppTextStyles.labelSmall.copyWith(
                                            color: AppColors.success,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  luggage['specs'] as String,
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),

                          // Selection Indicator
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: AppColors.primary,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),

              // Add New Luggage Button
              GestureDetector(
                onTap: _handleAddLuggage,
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add_circle_outline,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppConstants.spacingSm),
                      Text(
                        'Add New Luggage',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Navigation Buttons
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onBack,
                    child: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  flex: 2,
                  child: GradientButton(
                    text: 'Continue',
                    onPressed: _handleNext,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
