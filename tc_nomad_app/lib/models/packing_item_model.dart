import 'package:freezed_annotation/freezed_annotation.dart';

part 'packing_item_model.freezed.dart';
part 'packing_item_model.g.dart';

@freezed
class PackingItem with _$PackingItem {
  const factory PackingItem({
    required String id,
    required String name,
    required PackingCategory category,
    required int quantity,
    @Default(false) bool isPacked,
    String? emoji,
    String? instructions,
    PackingMethod? packingMethod,
    double? volume, // volume per item in liters
    double? weight, // weight per item in kg
    String? compartmentId,
    int? layerNumber,
    int? quadrantNumber,
    @Default(false) bool isCustom,
  }) = _PackingItem;

  factory PackingItem.fromJson(Map<String, dynamic> json) =>
      _$PackingItemFromJson(json);
}

enum PackingCategory {
  businessAttire,
  casualWear,
  weatherGear,
  toiletries,
  electronics,
  documents,
  personalCare,
  miscellaneous,
}

enum PackingMethod {
  rolling,
  folding,
  layering,
  bundling,
}
