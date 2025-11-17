import 'package:freezed_annotation/freezed_annotation.dart';
import 'trip_model.dart';

part 'airline_model.freezed.dart';
part 'airline_model.g.dart';

@freezed
class Airline with _$Airline {
  const factory Airline({
    required String id,
    required String name,
    required String code,
    String? logo,
    @Default({}) Map<FlightClass, BaggageRules> baggageRules,
  }) = _Airline;

  factory Airline.fromJson(Map<String, dynamic> json) =>
      _$AirlineFromJson(json);
}

@freezed
class BaggageRules with _$BaggageRules {
  const factory BaggageRules({
    // Carry-on
    required double carryOnMaxLength, // in cm
    required double carryOnMaxWidth, // in cm
    required double carryOnMaxHeight, // in cm
    required double carryOnMaxWeight, // in kg
    @Default(1) int carryOnQuantity,
    // Checked
    required double checkedMaxLength, // in cm
    required double checkedMaxWidth, // in cm
    required double checkedMaxHeight, // in cm
    required double checkedMaxWeight, // in kg
    @Default(1) int checkedQuantity,
    // Personal item
    @Default(true) bool allowsPersonalItem,
  }) = _BaggageRules;

  factory BaggageRules.fromJson(Map<String, dynamic> json) =>
      _$BaggageRulesFromJson(json);
}

@freezed
class ComplianceCheck with _$ComplianceCheck {
  const factory ComplianceCheck({
    required bool isCompliant,
    required bool sizeCompliant,
    required bool weightCompliant,
    required bool liquidCompliant,
    required bool prohibitedItemsCheck,
    @Default([]) List<String> warnings,
    @Default([]) List<String> violations,
  }) = _ComplianceCheck;

  factory ComplianceCheck.fromJson(Map<String, dynamic> json) =>
      _$ComplianceCheckFromJson(json);
}
