import 'package:intl/intl.dart';

/// Formatting Utilities
class Formatters {
  Formatters._();

  /// Format date to readable string
  static String formatDate(DateTime date, {String? pattern}) {
    final formatter = DateFormat(pattern ?? 'MMM dd, yyyy');
    return formatter.format(date);
  }

  /// Format date range
  static String formatDateRange(DateTime start, DateTime end) {
    return '${formatDate(start, pattern: 'MMM dd')} - ${formatDate(end, pattern: 'MMM dd, yyyy')}';
  }

  /// Format temperature
  static String formatTemperature(double temp, {bool isCelsius = true}) {
    return '${temp.toInt()}°${isCelsius ? 'C' : 'F'}';
  }

  /// Format weight
  static String formatWeight(double weight, {bool isMetric = true}) {
    return '${weight.toStringAsFixed(1)} ${isMetric ? 'kg' : 'lbs'}';
  }

  /// Format dimensions
  static String formatDimensions(double length, double width, double height, {bool isMetric = true}) {
    final unit = isMetric ? 'cm' : 'in';
    return '${length.toInt()}" × ${width.toInt()}" × ${height.toInt()}" $unit';
  }

  /// Format volume
  static String formatVolume(double volume) {
    return '${volume.toInt()}L';
  }

  /// Format percentage
  static String formatPercentage(double value) {
    return '${(value * 100).toInt()}%';
  }

  /// Format currency
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  /// Format duration (trip days)
  static String formatDuration(DateTime start, DateTime end) {
    final days = end.difference(start).inDays + 1;
    return '$days ${days == 1 ? 'day' : 'days'}';
  }

  /// Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Format item count
  static String formatItemCount(int count, String singular, {String? plural}) {
    return '$count ${count == 1 ? singular : (plural ?? '${singular}s')}';
  }

  /// Format list with commas
  static String formatList(List<String> items, {int maxItems = 3}) {
    if (items.isEmpty) return 'None';
    if (items.length <= maxItems) {
      return items.join(', ');
    }
    final visible = items.take(maxItems).join(', ');
    final remaining = items.length - maxItems;
    return '$visible +$remaining more';
  }
}
