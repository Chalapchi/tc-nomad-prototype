import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/subscription_service.dart';
import '../widgets/trip_info_step.dart';
import '../widgets/activities_step.dart';
import '../widgets/luggage_step.dart';
import '../widgets/weather_step.dart';
import '../widgets/suggestions_step.dart';
import '../../packing/screens/packing_list_screen.dart';
import '../../subscription/screens/paywall_screen.dart';

/// Trip Creation Wizard - 5 Steps
/// Complete flow for creating a new trip
/// Based on tc_nomad_enhanced_trip_flow.html wireframe
class TripCreationWizardScreen extends StatefulWidget {
  const TripCreationWizardScreen({super.key});

  @override
  State<TripCreationWizardScreen> createState() => _TripCreationWizardScreenState();
}

class _TripCreationWizardScreenState extends State<TripCreationWizardScreen> {
  int _currentStep = 0;
  final Map<String, dynamic> _tripData = {};

  final List<String> _stepTitles = [
    'Trip Info',
    'Activities',
    'Luggage',
    'Weather',
    'Details',
  ];

  void _nextStep() {
    if (_currentStep < _stepTitles.length - 1) {
      setState(() => _currentStep++);
    } else {
      _completeTripCreation();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _completeTripCreation() {
    // Show success message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        title: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Trip Created!',
                style: AppTextStyles.headlineMedium,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your trip to ${_tripData['destination']} has been created successfully.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: AppColors.info, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Next: Generate your AI-powered packing list',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.info,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('View Later'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!SubscriptionService.canGenerateAiList()) {
                // Show paywall when AI generation limit is reached
                Navigator.of(context).pop(); // Close dialog first
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PaywallScreen(canDismiss: true),
                  ),
                );
                return;
              }

              // Track trip creation
              SubscriptionService.incrementTrips();

              // Track AI generation usage
              SubscriptionService.incrementAiGenerations();

              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Close wizard
              // Navigate to packing list
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PackingListScreen(tripData: _tripData),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Generate Packing List'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Trip - ${_stepTitles[_currentStep]}'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Show confirmation dialog
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Cancel Trip Creation?'),
                content: const Text('Your progress will be lost.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Continue Editing'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                    child: const Text('Discard'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),

          // Step Content
          Expanded(
            child: IndexedStack(
              index: _currentStep,
              children: [
                // Step 1: Trip Info
                TripInfoStep(
                  onNext: _nextStep,
                  tripData: _tripData,
                ),

                // Step 2: Activities
                ActivitiesStep(
                  onNext: _nextStep,
                  onBack: _previousStep,
                  tripData: _tripData,
                ),

                // Step 3: Luggage
                LuggageStep(
                  onNext: _nextStep,
                  onBack: _previousStep,
                  tripData: _tripData,
                ),

                // Step 4: Weather
                WeatherStep(
                  onNext: _nextStep,
                  onBack: _previousStep,
                  tripData: _tripData,
                ),

                // Step 5: Suggestions
                SuggestionsStep(
                  onNext: _nextStep,
                  onBack: _previousStep,
                  tripData: _tripData,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingLg,
        vertical: AppConstants.spacingMd,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Step Dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_stepTitles.length, (index) {
                final isActive = index == _currentStep;
                final isCompleted = index < _currentStep;

                return Row(
                  children: [
                    Container(
                      width: isActive ? 32 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isActive || isCompleted
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    if (index < _stepTitles.length - 1)
                      const SizedBox(width: 6),
                  ],
                );
              }),
            ),
            const SizedBox(height: AppConstants.spacingSm),

            // Step Title & Count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step ${_currentStep + 1}: ${_stepTitles[_currentStep]}',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${_currentStep + 1}/${_stepTitles.length}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
