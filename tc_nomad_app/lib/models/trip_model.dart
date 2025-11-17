import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_model.freezed.dart';
part 'trip_model.g.dart';

@freezed
class Trip with _$Trip {
  const factory Trip({
    required String id,
    required String userId,
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    required TripType tripType,
    required TravelType travelType,
    String? airline,
    FlightClass? flightClass,
    @Default([]) List<String> activities,
    @Default(1) int numberOfTravelers,
    Gender? gender,
    String? description,
    String? suggestions,
    @Default([]) List<String> luggageIds,
    @Default(TripStatus.planning) TripStatus status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}

enum TripType {
  business,
  vacation,
  familyVisit,
  adventure,
  cultural,
  weekendGetaway,
  other,
}

enum TravelType {
  airplane,
  car,
  train,
  bus,
}

enum FlightClass {
  economy,
  premiumEconomy,
  business,
  first,
}

enum Gender {
  male,
  female,
  mixed,
  preferNotToSay,
}

enum TripStatus {
  planning,
  packing,
  ready,
  inProgress,
  completed,
}
