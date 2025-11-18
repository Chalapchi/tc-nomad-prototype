import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../services/weather_service.dart';

/// Weather Display Widget
/// Shows weather forecast with recommendations
class WeatherDisplayWidget extends StatefulWidget {
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final bool showRecommendations;
  final bool compact;

  const WeatherDisplayWidget({
    super.key,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.showRecommendations = true,
    this.compact = false,
  });

  @override
  State<WeatherDisplayWidget> createState() => _WeatherDisplayWidgetState();
}

class _WeatherDisplayWidgetState extends State<WeatherDisplayWidget> {
  WeatherForecast? _forecast;
  bool _isLoading = true;
  bool _useCelsius = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() => _isLoading = true);
    try {
      final forecast = await WeatherService.getWeatherForecast(
        widget.destination,
        widget.startDate,
        widget.endDate,
      );
      setState(() {
        _forecast = forecast;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  double _convertTemp(double celsius) {
    return _useCelsius ? celsius : (celsius * 9 / 5) + 32;
  }

  String _getTempString(double temp) {
    return '${_convertTemp(temp).toStringAsFixed(0)}°${_useCelsius ? 'C' : 'F'}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_forecast == null) {
      return _buildErrorState();
    }

    return widget.compact ? _buildCompactView() : _buildFullView();
  }

  Widget _buildLoadingState() {
    return GlassCard(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return GlassCard(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          children: [
            const Icon(Icons.cloud_off, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              'Weather data unavailable',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.cloud, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text('Weather Forecast', style: AppTextStyles.headlineSmall),
              ],
            ),
            // Temperature unit toggle
            GestureDetector(
              onTap: () => setState(() => _useCelsius = !_useCelsius),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  _useCelsius ? '°C' : '°F',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMd),

        // Summary
        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMd),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _forecast!.summary,
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),

        // Daily Forecasts
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _forecast!.forecasts.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppConstants.spacingMd),
            itemBuilder: (context, index) {
              return _buildDailyForecastCard(_forecast!.forecasts[index]);
            },
          ),
        ),

        // Recommendations
        if (widget.showRecommendations && _forecast!.recommendations.isNotEmpty) ...[
          const SizedBox(height: AppConstants.spacingLg),
          Text('Packing Recommendations', style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppConstants.spacingMd),
          ..._forecast!.recommendations.map((rec) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 8, right: 8),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(rec, style: AppTextStyles.bodyMedium),
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildCompactView() {
    return GlassCard(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cloud, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _forecast!.summary,
                    style: AppTextStyles.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingMd),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _forecast!.forecasts.take(5).length,
                separatorBuilder: (context, index) =>
                    const SizedBox(width: AppConstants.spacingSm),
                itemBuilder: (context, index) {
                  final forecast = _forecast!.forecasts[index];
                  return _buildCompactDayCard(forecast);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyForecastCard(DailyForecast forecast) {
    final dateFormat = DateFormat('EEE\nMMM d');

    return GlassCard(
      width: 110,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMd),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Date
            Text(
              dateFormat.format(forecast.date),
              style: AppTextStyles.labelMedium,
              textAlign: TextAlign.center,
            ),

            // Weather icon
            Text(
              forecast.icon,
              style: const TextStyle(fontSize: 32),
            ),

            // Temperature
            Column(
              children: [
                Text(
                  _getTempString(forecast.tempHigh),
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getTempString(forecast.tempLow),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            // Precipitation
            if (forecast.precipChance > 30)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.water_drop,
                    size: 12,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${forecast.precipChance}%',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactDayCard(DailyForecast forecast) {
    return Container(
      width: 60,
      padding: const EdgeInsets.all(AppConstants.spacingSm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusSm),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            DateFormat('EEE').format(forecast.date),
            style: AppTextStyles.labelSmall,
          ),
          Text(
            forecast.icon,
            style: const TextStyle(fontSize: 24),
          ),
          Text(
            _getTempString(forecast.tempHigh),
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
