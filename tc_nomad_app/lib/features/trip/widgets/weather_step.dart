import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import 'weather_display_widget.dart';

/// Step 4: Weather Forecast
/// Display weather forecast for destination and dates
class WeatherStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, dynamic> tripData;

  const WeatherStep({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.tripData,
  });

  @override
  State<WeatherStep> createState() => _WeatherStepState();
}

class _WeatherStepState extends State<WeatherStep> {
  @override
  Widget build(BuildContext context) {
    final destination = widget.tripData['destination'] as String? ?? 'Your Destination';
    final startDate = widget.tripData['startDate'] as DateTime? ?? DateTime.now();
    final endDate = widget.tripData['endDate'] as DateTime? ?? DateTime.now();

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            children: [
              Text(
                'Weather Forecast',
                style: AppTextStyles.headlineLarge,
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Text(
                'We\'ll adjust your packing list based on weather',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingXl),

              // Weather Display Widget
              WeatherDisplayWidget(
                destination: destination,
                startDate: startDate,
                endDate: endDate,
                showRecommendations: true,
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
                    onPressed: widget.onNext,
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
