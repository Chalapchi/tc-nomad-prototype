/// Application Constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'TC Nomad';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String apiBaseUrl = 'https://api.tcnomad.com'; // Replace with actual URL
  static const String openAiApiUrl = 'https://api.openai.com/v1';
  static const String weatherApiUrl = 'https://api.openweathermap.org/data/2.5';

  // API Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration connectTimeout = Duration(seconds: 15);

  // Local Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyThemeMode = 'theme_mode';
  static const String keyTemperatureUnit = 'temperature_unit';
  static const String keyMeasurementUnit = 'measurement_unit';

  // Freemium Limits
  static const int freeTripsPerMonth = 1;
  static const int freeAiGenerations = 3;
  static const int freeLuggageProfiles = 1;

  // Subscription Pricing
  static const String monthlyPrice = '\$1.99';
  static const String annualPrice = '\$9.99';
  static const double annualSavings = 0.58; // 58% savings

  // Packing List Categories
  static const List<String> packingCategories = [
    'Business Attire',
    'Casual Wear',
    'Weather Gear',
    'Toiletries',
    'Electronics',
    'Documents',
    'Personal Care',
    'Miscellaneous',
  ];

  // Trip Types
  static const List<String> tripTypes = [
    'Business Trip',
    'Vacation',
    'Family Visit',
    'Adventure',
    'Cultural',
    'Weekend Getaway',
    'Other',
  ];

  // Travel Types
  static const List<String> travelTypes = [
    'Airplane',
    'Car',
    'Train',
    'Bus',
  ];

  // Activities
  static const List<String> activities = [
    'Business Meetings',
    'Conference',
    'Gym/Fitness',
    'Sightseeing',
    'Dining',
    'Shopping',
    'Beach',
    'Hiking',
    'Swimming',
    'Photography',
  ];

  // Luggage Types
  static const List<String> luggageTypes = [
    'Carry-On Suitcase',
    'Checked Suitcase',
    'Backpack',
    'Duffel Bag',
    'Garment Bag',
  ];

  // Compartment Types
  static const List<String> compartmentTypes = [
    'Main Compartment',
    'Front Pocket',
    'Laptop Sleeve',
    'Side Pocket',
    'Shoe Compartment',
    'Toiletry Pocket',
  ];

  // Packing Methods
  static const List<String> packingMethods = [
    'Rolling',
    'Folding',
    'Layering',
    'Bundling',
  ];

  // Volume Thresholds
  static const double volumeLowThreshold = 0.5; // 50%
  static const double volumeHighThreshold = 0.85; // 85%

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacing2xl = 48.0;

  // Border Radius
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  static const double radius2xl = 30.0;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxCustomItems = 20;
  static const int maxLuggageProfiles = 10;
  static const int maxTripDuration = 365; // days
}
