import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';

/// Step 2: Activities Selection
/// Multi-select grid of activities
class ActivitiesStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, dynamic> tripData;

  const ActivitiesStep({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.tripData,
  });

  @override
  State<ActivitiesStep> createState() => _ActivitiesStepState();
}

class _ActivitiesStepState extends State<ActivitiesStep> {
  late Set<String> _selectedActivities;

  final Map<String, String> _activityEmojis = {
    'Business Meetings': '🏢',
    'Conference': '📚',
    'Gym/Fitness': '🏃',
    'Sightseeing': '🗺️',
    'Dining': '🍽️',
    'Shopping': '🛍️',
    'Beach': '🏖️',
    'Hiking': '🥾',
    'Swimming': '🏊',
    'Photography': '📸',
  };

  @override
  void initState() {
    super.initState();
    _selectedActivities = Set<String>.from(
      widget.tripData['activities'] ?? <String>[],
    );
  }

  void _handleNext() {
    widget.tripData['activities'] = _selectedActivities.toList();
    widget.onNext();
  }

  void _toggleActivity(String activity) {
    setState(() {
      if (_selectedActivities.contains(activity)) {
        _selectedActivities.remove(activity);
      } else {
        _selectedActivities.add(activity);
      }
    });
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
                'What will you be doing?',
                style: AppTextStyles.headlineLarge,
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Text(
                'Select all activities that apply',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Activity Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppConstants.spacingMd,
                  mainAxisSpacing: AppConstants.spacingMd,
                  childAspectRatio: 1.2,
                ),
                itemCount: _activityEmojis.length,
                itemBuilder: (context, index) {
                  final activity = _activityEmojis.keys.elementAt(index);
                  final emoji = _activityEmojis[activity]!;
                  final isSelected = _selectedActivities.contains(activity);

                  return GestureDetector(
                    onTap: () => _toggleActivity(activity),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: AppConstants.spacingSm),
                          Text(
                            activity,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: AppConstants.spacingLg),

              // Selected count
              if (_selectedActivities.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                  child: Text(
                    '${_selectedActivities.length} ${_selectedActivities.length == 1 ? 'activity' : 'activities'} selected',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
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
