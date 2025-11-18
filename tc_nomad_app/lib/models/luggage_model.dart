import 'package:freezed_annotation/freezed_annotation.dart';

part 'luggage_model.freezed.dart';
part 'luggage_model.g.dart';

@freezed
class Luggage with _$Luggage {
  const factory Luggage({
    required String id,
    required String userId,
    required String name,
    required LuggageType type,
    required double length, // in cm
    required double width, // in cm
    required double height, // in cm
    required double volume, // in liters
    @Default([]) List<Compartment> compartments,
    @Default(false) bool isDefault,
    String? color,
    String? brand,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Luggage;

  factory Luggage.fromJson(Map<String, dynamic> json) =>
      _$LuggageFromJson(json);
}

@freezed
class Compartment with _$Compartment {
  const factory Compartment({
    required String id,
    required String name,
    required CompartmentType type,
    required double volume, // in liters
    @Default(1) int layers,
    @Default(4) int quadrants,
  }) = _Compartment;

  factory Compartment.fromJson(Map<String, dynamic> json) =>
      _$CompartmentFromJson(json);
}

enum LuggageType {
  carryOnSuitcase,
  checkedSuitcase,
  backpack,
  duffelBag,
  garmentBag,
}

enum CompartmentType {
  main,
  frontPocket,
  laptopSleeve,
  sidePocket,
  shoeCompartment,
  toiletryPocket,
}
