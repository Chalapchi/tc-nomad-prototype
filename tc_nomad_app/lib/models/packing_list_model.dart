import 'package:freezed_annotation/freezed_annotation.dart';
import 'packing_item_model.dart';

part 'packing_list_model.freezed.dart';
part 'packing_list_model.g.dart';

@freezed
class PackingList with _$PackingList {
  const factory PackingList({
    required String id,
    required String tripId,
    required String luggageId,
    @Default([]) List<PackingItem> items,
    @Default(PackingMode.volume) PackingMode mode,
    @Default(0.0) double totalVolume,
    @Default(0.0) double totalWeight,
    @Default(0.0) double volumeUsagePercentage,
    DateTime? generatedAt,
    DateTime? updatedAt,
  }) = _PackingList;

  factory PackingList.fromJson(Map<String, dynamic> json) =>
      _$PackingListFromJson(json);
}

enum PackingMode {
  volume, // Maximize space
  access, // Easy access/retrieval
}
