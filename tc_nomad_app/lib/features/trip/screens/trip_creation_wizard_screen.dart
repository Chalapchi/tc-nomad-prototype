import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';

/// Trip Creation Wizard - 5 Steps
/// Based on tc_nomad_enhanced_trip_flow.html wireframe
class TripCreationWizardScreen extends StatefulWidget {
  const TripCreationWizardScreen({super.key});

  @override
  State<TripCreationWizardScreen> createState() => _TripCreationWizardScreenState();
}

class _TripCreationWizardScreenState extends State<TripCreationWizardScreen> {
  int _currentStep = 0;

  final List<String> _stepTitles = [
    'Trip Info',
    'Activities',
    'Luggage',
    'Weather',
    'Details & Suggestions',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Trip - ${_stepTitles[_currentStep]}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / _stepTitles.length,
            backgroundColor: AppColors.background,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),

          // Step Content
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.construction,
                      size: 80,
                      color: AppColors.textTertiary.withOpacity(0.5),
                    ),
                    const SizedBox(height: AppConstants.spacingLg),
                    Text(
                      'Step ${_currentStep + 1}: ${_stepTitles[_currentStep]}',
                      style: AppTextStyles.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    Text(
                      'This screen will be fully implemented with form fields matching the wireframes',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() => _currentStep--);
                      },
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  flex: 2,
                  child: GradientButton(
                    text: _currentStep < _stepTitles.length - 1 ? 'Continue' : 'Generate Packing List',
                    onPressed: () {
                      if (_currentStep < _stepTitles.length - 1) {
                        setState(() => _currentStep++);
                      } else {
                        // Navigate to packing list
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
