import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/utils/formatters.dart';

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
  // Mock weather data (replace with actual API call)
  final List<Map<String, dynamic>> _mockWeather = [
    {'day': 'Tue', 'icon': '🌤️', 'temp': 18},
    {'day': 'Wed', 'icon': '☁️', 'temp': 15},
    {'day': 'Thu', 'icon': '🌧️', 'temp': 12},
    {'day': 'Fri', 'icon': '⛅', 'temp': 16},
  ];

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
              const SizedBox(height: AppConstants.spacingLg),

              // Weather Widget
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location & Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                destination,
                                style: AppTextStyles.headlineMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Formatters.formatDateRange(startDate, endDate),
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '16°C',
                          style: AppTextStyles.displayLarge.copyWith(
                            color: Colors.white,
                            fontSize: 48,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingLg),

                    // Daily Forecast
                    Row(
                      children: _mockWeather.map((day) {
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.spacingMd,
                              horizontal: AppConstants.spacingSm,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  day['day'] as String,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  day['icon'] as String,
                                  style: const TextStyle(fontSize: 28),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${day['temp']}°',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Weather Notes Card
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingLg),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.warning,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Key Weather Notes',
                          style: AppTextStyles.labelLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingMd),
                    _buildWeatherNote('Expect rain on Thursday - pack waterproof jacket'),
                    _buildWeatherNote('Cool temperatures (12-18°C) - bring layers'),
                    _buildWeatherNote('Mix of sun and clouds - versatile clothing recommended'),
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

  Widget _buildWeatherNote(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
