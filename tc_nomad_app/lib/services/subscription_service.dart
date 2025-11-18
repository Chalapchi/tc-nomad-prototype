/// Subscription Service
/// Manages subscription status and usage limits
///
/// NOTE: Freemium gating is DISABLED for wireframe/demo purposes.
/// All limits return true (no blocking), but tracking is kept for presentation.
class SubscriptionService {
  // Mock subscription state (should be replaced with actual state management)
  static bool _isPro = false;
  static int _tripsCreated = 0;
  static int _aiGenerationsUsed = 0;

  // Free tier limits (for display purposes only - not enforced)
  static const int freeTripsLimit = 1;
  static const int freeAiGenerationsLimit = 3;

  /// Check if user is Pro subscriber
  static bool get isPro => _isPro;

  /// Set subscription status (for testing/mock)
  static void setProStatus(bool isPro) {
    _isPro = isPro;
  }

  /// Check if user can create a new trip
  /// NOTE: Always returns TRUE for wireframe mode (no blocking)
  static bool canCreateTrip() {
    return true; // Always allow for demo
    // if (_isPro) return true;
    // return _tripsCreated < freeTripsLimit;
  }

  /// Check if user can generate AI packing list
  /// NOTE: Always returns TRUE for wireframe mode (no blocking)
  static bool canGenerateAiList() {
    return true; // Always allow for demo
    // if (_isPro) return true;
    // return _aiGenerationsUsed < freeAiGenerationsLimit;
  }

  /// Get trips usage info
  static UsageInfo getTripsUsage() {
    return UsageInfo(
      used: _tripsCreated,
      limit: _isPro ? -1 : freeTripsLimit, // -1 = unlimited
      isUnlimited: _isPro,
    );
  }

  /// Get AI generations usage info
  static UsageInfo getAiGenerationsUsage() {
    return UsageInfo(
      used: _aiGenerationsUsed,
      limit: _isPro ? -1 : freeAiGenerationsLimit,
      isUnlimited: _isPro,
    );
  }

  /// Increment trip counter
  static void incrementTrips() {
    _tripsCreated++;
  }

  /// Increment AI generations counter
  static void incrementAiGenerations() {
    _aiGenerationsUsed++;
  }

  /// Reset usage (for testing)
  static void resetUsage() {
    _tripsCreated = 0;
    _aiGenerationsUsed = 0;
  }

  /// Get subscription features based on tier
  static SubscriptionFeatures getFeatures() {
    return SubscriptionFeatures(
      unlimitedTrips: _isPro,
      unlimitedAiGenerations: _isPro,
      extendedWeather: _isPro,
      advancedPackingGuide: _isPro,
      unlimitedLuggage: _isPro,
      allAirlines: _isPro,
      cloudSync: _isPro,
      prioritySupport: _isPro,
    );
  }

  /// Check if feature is available
  static bool isFeatureAvailable(SubscriptionFeatureType feature) {
    final features = getFeatures();
    switch (feature) {
      case SubscriptionFeatureType.unlimitedTrips:
        return features.unlimitedTrips;
      case SubscriptionFeatureType.unlimitedAi:
        return features.unlimitedAiGenerations;
      case SubscriptionFeatureType.extendedWeather:
        return features.extendedWeather;
      case SubscriptionFeatureType.advancedPacking:
        return features.advancedPackingGuide;
      case SubscriptionFeatureType.unlimitedLuggage:
        return features.unlimitedLuggage;
      case SubscriptionFeatureType.allAirlines:
        return features.allAirlines;
      case SubscriptionFeatureType.cloudSync:
        return features.cloudSync;
      case SubscriptionFeatureType.prioritySupport:
        return features.prioritySupport;
    }
  }

  /// Get upgrade message for feature
  static String getUpgradeMessage(SubscriptionFeatureType feature) {
    switch (feature) {
      case SubscriptionFeatureType.unlimitedTrips:
        return 'Upgrade to Pro for unlimited trips';
      case SubscriptionFeatureType.unlimitedAi:
        return 'Upgrade to Pro for unlimited AI generations';
      case SubscriptionFeatureType.extendedWeather:
        return 'Upgrade to Pro for extended 14-day weather forecasts';
      case SubscriptionFeatureType.advancedPacking:
        return 'Upgrade to Pro for advanced packing features';
      case SubscriptionFeatureType.unlimitedLuggage:
        return 'Upgrade to Pro for unlimited luggage profiles';
      case SubscriptionFeatureType.allAirlines:
        return 'Upgrade to Pro for 100+ airline compliance';
      case SubscriptionFeatureType.cloudSync:
        return 'Upgrade to Pro for cloud sync across devices';
      case SubscriptionFeatureType.prioritySupport:
        return 'Upgrade to Pro for 24/7 priority support';
    }
  }
}

// Models
class UsageInfo {
  final int used;
  final int limit; // -1 for unlimited
  final bool isUnlimited;

  UsageInfo({
    required this.used,
    required this.limit,
    required this.isUnlimited,
  });

  double get percentage {
    if (isUnlimited) return 0.0;
    return (used / limit).clamp(0.0, 1.0);
  }

  bool get isAtLimit {
    if (isUnlimited) return false;
    return used >= limit;
  }

  bool get isNearLimit {
    if (isUnlimited) return false;
    return percentage >= 0.8;
  }

  String get displayText {
    if (isUnlimited) return 'Unlimited';
    return '$used / $limit';
  }
}

class SubscriptionFeatures {
  final bool unlimitedTrips;
  final bool unlimitedAiGenerations;
  final bool extendedWeather;
  final bool advancedPackingGuide;
  final bool unlimitedLuggage;
  final bool allAirlines;
  final bool cloudSync;
  final bool prioritySupport;

  SubscriptionFeatures({
    required this.unlimitedTrips,
    required this.unlimitedAiGenerations,
    required this.extendedWeather,
    required this.advancedPackingGuide,
    required this.unlimitedLuggage,
    required this.allAirlines,
    required this.cloudSync,
    required this.prioritySupport,
  });
}

enum SubscriptionFeatureType {
  unlimitedTrips,
  unlimitedAi,
  extendedWeather,
  advancedPacking,
  unlimitedLuggage,
  allAirlines,
  cloudSync,
  prioritySupport,
}
