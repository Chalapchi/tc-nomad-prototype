import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/custom_text_field.dart';

/// Step 5: Trip Suggestions & Details
/// Optional description and suggestions for AI personalization
class SuggestionsStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, dynamic> tripData;

  const SuggestionsStep({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.tripData,
  });

  @override
  State<SuggestionsStep> createState() => _SuggestionsStepState();
}

class _SuggestionsStepState extends State<SuggestionsStep> {
  late TextEditingController _suggestionsController;

  @override
  void initState() {
    super.initState();
    _suggestionsController = TextEditingController(
      text: widget.tripData['suggestions'] ?? '',
    );
  }

  @override
  void dispose() {
    _suggestionsController.dispose();
    super.dispose();
  }

  void _handleSkip() {
    widget.tripData['suggestions'] = null;
    widget.onNext();
  }

  void _handleContinue() {
    final suggestions = _suggestionsController.text.trim();
    widget.tripData['suggestions'] = suggestions.isNotEmpty ? suggestions : null;
    widget.onNext();
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
                'Tell Us More About Your Trip',
                style: AppTextStyles.headlineLarge,
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Text(
                'Share any additional details, preferences, or special requirements to help us personalize your packing recommendations',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Suggestions Text Area
              CustomTextField(
                label: 'Trip Description & Suggestions (Optional)',
                hint: 'Example: I\'ll be attending evening networking events and plan to visit museums. I prefer comfortable walking shoes and need space for souvenirs on the return trip...',
                controller: _suggestionsController,
                maxLines: 8,
              ),
              const SizedBox(height: AppConstants.spacingSm),

              // Helper Text
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  border: Border.all(
                    color: AppColors.info.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: AppColors.info,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'The more details you provide, the better we can tailor your packing list',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.info,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // What to Include Card
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What to include:',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _buildSuggestionItem('Specific events or activities not listed earlier'),
                    _buildSuggestionItem('Dress code requirements'),
                    _buildSuggestionItem('Personal preferences (e.g., minimalist packing)'),
                    _buildSuggestionItem('Health or mobility considerations'),
                    _buildSuggestionItem('Shopping or souvenirs plans'),
                    _buildSuggestionItem('Any items you definitely want/don\'t want'),
                  ],
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
            child: Column(
              children: [
                GradientButton(
                  text: 'Continue to AI Recommendations',
                  onPressed: _handleContinue,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onBack,
                        child: const Text('Previous'),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: TextButton(
                        onPressed: _handleSkip,
                        child: Text(
                          'Skip - Use Standard',
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
