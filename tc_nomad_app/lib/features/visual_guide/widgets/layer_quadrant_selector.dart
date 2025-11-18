import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';

/// Layer & Quadrant Selector Widget
/// Interactive grid for selecting layer and quadrant position
class LayerQuadrantSelector extends StatelessWidget {
  final int selectedLayer;
  final int selectedQuadrant;
  final int totalLayers;
  final Function(int layer, int quadrant) onSelect;
  final Map<String, int> itemCounts; // Count of items per position

  const LayerQuadrantSelector({
    super.key,
    required this.selectedLayer,
    required this.selectedQuadrant,
    required this.totalLayers,
    required this.onSelect,
    this.itemCounts = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.layers, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('Packing Position', style: AppTextStyles.labelLarge),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // Layer Selector
          Text('Layer:', style: AppTextStyles.caption),
          const SizedBox(height: AppConstants.spacingSm),
          Row(
            children: List.generate(totalLayers, (index) {
              final layer = index + 1;
              final isSelected = layer == selectedLayer;
              return Padding(
                padding: const EdgeInsets.only(right: AppConstants.spacingSm),
                child: GestureDetector(
                  onTap: () => onSelect(layer, selectedQuadrant),
                  child: Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.primaryGradient : null,
                      color: isSelected ? null : AppColors.background,
                      borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getLayerName(layer),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // Quadrant Selector (2x2 grid)
          Text('Quadrant:', style: AppTextStyles.caption),
          const SizedBox(height: AppConstants.spacingSm),
          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                final quadrant = index + 1;
                final isSelected = quadrant == selectedQuadrant;
                final positionKey = '${selectedLayer}_$quadrant';
                final itemCount = itemCounts[positionKey] ?? 0;

                return GestureDetector(
                  onTap: () => onSelect(selectedLayer, quadrant),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.primaryGradient : null,
                      color: isSelected ? null : AppColors.background,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Quadrant label
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getQuadrantIcon(quadrant),
                                color: isSelected ? Colors.white : AppColors.textSecondary,
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _getQuadrantName(quadrant),
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: isSelected ? Colors.white : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Item count badge
                        if (itemCount > 0)
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$itemCount',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Helper text
          const SizedBox(height: AppConstants.spacingSm),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, size: 14, color: AppColors.info),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Pack heavy items at the bottom for stability',
                    style: AppTextStyles.caption.copyWith(color: AppColors.info),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLayerName(int layer) {
    switch (layer) {
      case 1:
        return 'Bottom';
      case 2:
        return 'Middle';
      case 3:
        return 'Top';
      default:
        return 'L$layer';
    }
  }

  String _getQuadrantName(int quadrant) {
    switch (quadrant) {
      case 1:
        return 'Top L';
      case 2:
        return 'Top R';
      case 3:
        return 'Bot L';
      case 4:
        return 'Bot R';
      default:
        return 'Q$quadrant';
    }
  }

  IconData _getQuadrantIcon(int quadrant) {
    switch (quadrant) {
      case 1:
        return Icons.arrow_upward;
      case 2:
        return Icons.arrow_forward;
      case 3:
        return Icons.arrow_back;
      case 4:
        return Icons.arrow_downward;
      default:
        return Icons.grid_4x4;
    }
  }
}

/// Visual Layer Display Widget
/// Shows 3D representation of layers
class LayerVisualizationWidget extends StatelessWidget {
  final int totalLayers;
  final int selectedLayer;
  final Map<int, List<String>> itemsByLayer; // Layer -> emoji list

  const LayerVisualizationWidget({
    super.key,
    required this.totalLayers,
    required this.selectedLayer,
    this.itemsByLayer = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(totalLayers, (index) {
          final layer = totalLayers - index; // Reverse order (bottom to top)
          final isSelected = layer == selectedLayer;
          final items = itemsByLayer[layer] ?? [];
          final layerHeight = 40.0 + (index * 20.0);

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Layer label
              Text(
                _getLayerName(layer),
                style: AppTextStyles.labelSmall.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textTertiary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              // Layer box
              Container(
                width: 80,
                height: layerHeight,
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? AppColors.primaryGradient
                      : LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.grey[300]!,
                            Colors.grey[400]!,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Stack(
                  children: [
                    // Item count or items
                    if (items.isNotEmpty)
                      Center(
                        child: items.length <= 3
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: items
                                    .map((emoji) => Text(
                                          emoji,
                                          style: const TextStyle(fontSize: 16),
                                        ))
                                    .toList(),
                              )
                            : Text(
                                '${items.length}',
                                style: AppTextStyles.headlineSmall.copyWith(
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  String _getLayerName(int layer) {
    switch (layer) {
      case 1:
        return 'Bottom';
      case 2:
        return 'Middle';
      case 3:
        return 'Top';
      default:
        return 'Layer $layer';
    }
  }
}
