import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
    @Default(SubscriptionTier.free) SubscriptionTier subscriptionTier,
    DateTime? subscriptionExpiryDate,
    @Default(PreferencesModel()) PreferencesModel preferences,
    @Default(UsageLimits()) UsageLimits usageLimits,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class PreferencesModel with _$PreferencesModel {
  const factory PreferencesModel({
    @Default(TemperatureUnit.celsius) TemperatureUnit temperatureUnit,
    @Default(MeasurementUnit.metric) MeasurementUnit measurementUnit,
    @Default(ThemeMode.system) ThemeMode themeMode,
  }) = _PreferencesModel;

  factory PreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$PreferencesModelFromJson(json);
}

@freezed
class UsageLimits with _$UsageLimits {
  const factory UsageLimits({
    @Default(0) int tripsThisMonth,
    @Default(0) int aiGenerationsUsed,
    @Default(0) int luggageProfilesCount,
    DateTime? lastResetDate,
  }) = _UsageLimits;

  factory UsageLimits.fromJson(Map<String, dynamic> json) =>
      _$UsageLimitsFromJson(json);
}

enum SubscriptionTier { free, pro }

enum TemperatureUnit { celsius, fahrenheit }

enum MeasurementUnit { metric, imperial }

enum ThemeMode { light, dark, system }
