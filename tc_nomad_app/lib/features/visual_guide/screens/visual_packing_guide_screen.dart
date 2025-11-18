import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../packing/screens/packing_list_screen.dart';
import '../widgets/flying_emoji_animation.dart';
import '../widgets/packing_technique_modal.dart';
import '../widgets/volume_usage_widget.dart';
import '../widgets/layer_quadrant_selector.dart';

/// Visual Packing Guide Screen
/// Interactive packing with compartments, layers, and quadrants
/// Based on tc-nomad-step2b-visual-guide.html - THE UNIQUE FEATURE!
class VisualPackingGuideScreen extends StatefulWidget {
  final Map<String, dynamic> tripData;
  final List<PackingCategory> packingList;

  const VisualPackingGuideScreen({
    super.key,
    required this.tripData,
    required this.packingList,
  });

  @override
  State<VisualPackingGuideScreen> createState() => _VisualPackingGuideScreenState();
}

class _VisualPackingGuideScreenState extends State<VisualPackingGuideScreen> {
  String _selectedCompartment = 'main';
  int _currentStage = 1;
  final Map<String, List<PackedItemPosition>> _packedItems = {};
  final List<Widget> _flyingAnimations = [];
  final GlobalKey _luggageKey = GlobalKey();

  // Layer and quadrant selection
  int _selectedLayer = 1;
  int _selectedQuadrant = 1;

  // Volume tracking
  final double _totalLuggageCapacity = VolumeCalculator.getLuggageCapacity('carry-on');
  final Map<String, double> _compartmentVolumes = {};

  final List<CompartmentInfo> _compartments = [
    CompartmentInfo(id: 'main', name: 'Main Compartment', emoji: '📦', layers: 3),
    CompartmentInfo(id: 'front', name: 'Front Pocket', emoji: '👝', layers: 1),
    CompartmentInfo(id: 'laptop', name: 'Laptop Sleeve', emoji: '💻', layers: 1),
    CompartmentInfo(id: 'side', name: 'Side Pocket', emoji: '📂', layers: 1),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize packed items map and volumes
    for (var comp in _compartments) {
      _packedItems[comp.id] = [];
      _compartmentVolumes[comp.id] = 0.0;
    }
  }

  double get _currentCompartmentCapacity {
    return VolumeCalculator.getCompartmentCapacity(
      _selectedCompartment,
      _totalLuggageCapacity,
    );
  }

  double get _currentCompartmentUsage {
    return _compartmentVolumes[_selectedCompartment] ?? 0.0;
  }

  int get _currentCompartmentLayers {
    return _compartments
        .firstWhere((c) => c.id == _selectedCompartment)
        .layers;
  }

  Map<String, int> get _itemCountsByPosition {
    final counts = <String, int>{};
    final items = _packedItems[_selectedCompartment] ?? [];
    for (var packedItem in items) {
      final key = '${packedItem.layer}_${packedItem.quadrant}';
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts;
  }

  Map<int, List<String>> get _itemsByLayer {
    final itemsByLayer = <int, List<String>>{};
    final items = _packedItems[_selectedCompartment] ?? [];
    for (var packedItem in items) {
      itemsByLayer[packedItem.layer] ??= [];
      itemsByLayer[packedItem.layer]!.add(packedItem.item.emoji);
    }
    return itemsByLayer;
  }

  List<PackingItemModel> get _unpackedItems {
    return widget.packingList
        .expand((cat) => cat.items)
        .where((item) => !item.isPacked)
        .toList();
  }

  int get _totalItemsToPack {
    return widget.packingList.expand((cat) => cat.items).length;
  }

  int get _packedItemsCount {
    return _packedItems.values.expand((list) => list).length;
  }

  double get _packingProgress {
    return _totalItemsToPack > 0 ? _packedItemsCount / _totalItemsToPack : 0.0;
  }

  void _packItem(PackingItemModel item, Offset itemPosition) {
    // Calculate volume
    final itemVolume = VolumeCalculator.estimateItemVolume(item.name, item.quantity);
    final currentUsage = _compartmentVolumes[_selectedCompartment] ?? 0.0;
    final capacity = _currentCompartmentCapacity;

    // Check if overpacked
    if (currentUsage + itemVolume > capacity) {
      _showOverpackWarning(item, itemVolume);
      return;
    }

    setState(() {
      // Add item to current compartment with selected layer/quadrant
      _packedItems[_selectedCompartment]!.add(PackedItemPosition(
        item: item,
        layer: _selectedLayer,
        quadrant: _selectedQuadrant,
      ));
      // Update volume
      _compartmentVolumes[_selectedCompartment] = currentUsage + itemVolume;
      // Mark as packed
      item.isPacked = true;
    });

    // Show flying animation
    _showPackingAnimation(item, itemPosition);
  }

  void _showPackingAnimation(PackingItemModel item, Offset startPosition) {
    // Get luggage position
    final RenderBox? luggageBox = _luggageKey.currentContext?.findRenderObject() as RenderBox?;
    if (luggageBox == null) return;

    final luggagePosition = luggageBox.localToGlobal(Offset.zero);
    final luggageCenter = Offset(
      luggagePosition.dx + luggageBox.size.width / 2,
      luggagePosition.dy + luggageBox.size.height / 2,
    );

    // Create animation
    final animation = FlyingEmojiAnimation(
      emoji: item.emoji,
      startPosition: startPosition,
      endPosition: luggageCenter,
      onComplete: () {
        setState(() {
          _flyingAnimations.removeAt(0);
        });
      },
    );

    setState(() {
      _flyingAnimations.add(animation);
    });
  }

  void _showOverpackWarning(PackingItemModel item, double requiredVolume) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        title: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warning,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Compartment Full'),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Not enough space in ${_compartments.firstWhere((c) => c.id == _selectedCompartment).name}.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: AppColors.info, size: 20),
                      const SizedBox(width: 8),
                      Text('Suggestions:', style: AppTextStyles.labelLarge),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Try a different compartment\n• Use compression bags\n• Remove some items',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got It'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visual Packing Guide'),
        actions: [
          IconButton(
            icon: const Icon(Icons.school_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const PackingTechniqueModal(),
              );
            },
            tooltip: 'Packing Techniques',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Stage Indicator
              _buildStageIndicator(),

              // Compartment Tabs
              _buildCompartmentTabs(),

              // Volume Usage
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingMd,
                  vertical: AppConstants.spacingSm,
                ),
                child: VolumeUsageWidget(
                  usedVolume: _currentCompartmentUsage,
                  totalVolume: _currentCompartmentCapacity,
                  compartmentName: _compartments
                      .firstWhere((c) => c.id == _selectedCompartment)
                      .name,
                ),
              ),

              // Visual Packing Area
              Expanded(
                child: Row(
                  children: [
                    // Main packing area
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // Luggage Visualization
                          Expanded(
                            flex: 2,
                            child: _buildLuggageVisualization(),
                          ),

                          // Item Checklist
                          Expanded(
                            flex: 3,
                            child: _buildItemChecklist(),
                          ),
                        ],
                      ),
                    ),

                    // Layer & Quadrant Selector (sidebar)
                    Container(
                      width: 180,
                      padding: const EdgeInsets.all(AppConstants.spacingSm),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Layer visualization
                            LayerVisualizationWidget(
                              totalLayers: _currentCompartmentLayers,
                              selectedLayer: _selectedLayer,
                              itemsByLayer: _itemsByLayer,
                            ),
                            const SizedBox(height: AppConstants.spacingMd),

                            // Layer & Quadrant Selector
                            LayerQuadrantSelector(
                              selectedLayer: _selectedLayer,
                              selectedQuadrant: _selectedQuadrant,
                              totalLayers: _currentCompartmentLayers,
                              itemCounts: _itemCountsByPosition,
                              onSelect: (layer, quadrant) {
                                setState(() {
                                  _selectedLayer = layer;
                                  _selectedQuadrant = quadrant;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Complete Button
              _buildCompleteButton(),
            ],
          ),
          // Flying animations overlay
          ..._flyingAnimations,
        ],
      ),
    );
  }

  Widget _buildStageIndicator() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Stage $_currentStage: Foundation Items',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                ),
                Text(
                  '$_packedItemsCount of $_totalItemsToPack packed',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.spacingSm),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _packingProgress,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompartmentTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _compartments.map((comp) {
            final isSelected = _selectedCompartment == comp.id;
            final isDisabled = comp.disabled;

            return Padding(
              padding: const EdgeInsets.only(right: AppConstants.spacingSm),
              child: GestureDetector(
                onTap: isDisabled ? null : () {
                  setState(() => _selectedCompartment = comp.id);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMd,
                    vertical: AppConstants.spacingSm,
                  ),
                  decoration: BoxDecoration(
                    color: isDisabled
                        ? AppColors.background
                        : (isSelected ? AppColors.primary : Colors.white),
                    border: Border.all(
                      color: isDisabled
                          ? AppColors.textDisabled
                          : (isSelected ? AppColors.primary : AppColors.border),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSm),
                  ),
                  child: Row(
                    children: [
                      Text(
                        comp.emoji,
                        style: TextStyle(
                          fontSize: 16,
                          opacity: isDisabled ? 0.5 : 1,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        comp.name,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isDisabled
                              ? AppColors.textDisabled
                              : (isSelected ? Colors.white : AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLuggageVisualization() {
    final compartmentItems = _packedItems[_selectedCompartment] ?? [];

    return Container(
      key: _luggageKey,
      margin: const EdgeInsets.all(AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[100]!, Colors.grey[200]!],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: AppColors.border, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Luggage Icon with animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.95, end: 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: const Text(
              '🧳',
              style: TextStyle(fontSize: 80),
            ),
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // Packed Items Display with grid layout
          if (compartmentItems.isNotEmpty)
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: compartmentItems.length,
                itemBuilder: (context, index) {
                  final packed = compartmentItems[index];
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, opacity, child) {
                      return Opacity(opacity: opacity, child: child);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.success.withOpacity(0.3)),
                      ),
                      child: Center(
                        child: Text(
                          packed.item.emoji,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Text(
              'Tap items below to pack',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItemChecklist() {
    final compartmentName = _compartments
        .firstWhere((c) => c.id == _selectedCompartment)
        .name;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pack into $compartmentName',
                style: AppTextStyles.headlineSmall,
              ),
              Text(
                '${_unpackedItems.length} left',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Expanded(
            child: _unpackedItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('🎉', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: AppConstants.spacingMd),
                        Text(
                          'All items packed!',
                          style: AppTextStyles.headlineMedium,
                        ),
                        const SizedBox(height: AppConstants.spacingSm),
                        Text(
                          'Tap Complete Trip below',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: _unpackedItems.take(8).length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppConstants.spacingSm),
                    itemBuilder: (context, index) {
                      final item = _unpackedItems[index];
                      return GestureDetector(
                        onTapDown: (details) {
                          final RenderBox box = context.findRenderObject() as RenderBox;
                          final position = box.localToGlobal(details.localPosition);
                          _packItem(item, position);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(AppConstants.spacingMd),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              // Emoji
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Center(
                                  child: Text(
                                    item.emoji,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppConstants.spacingMd),
                              // Item info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: AppTextStyles.bodyMedium),
                                    Text(
                                      'Qty: ${item.quantity} • ${VolumeCalculator.estimateItemVolume(item.name, item.quantity).toStringAsFixed(1)}L',
                                      style: AppTextStyles.caption,
                                    ),
                                  ],
                                ),
                              ),
                              // Pack icon
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteButton() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: GradientButton(
          text: _packingProgress >= 1.0 ? 'Complete Trip' : 'Continue Packing',
          onPressed: () {
            if (_packingProgress >= 1.0) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
        ),
      ),
    );
  }
}

// Helper Classes
class CompartmentInfo {
  final String id;
  final String name;
  final String emoji;
  final int layers;
  final bool disabled;

  CompartmentInfo({
    required this.id,
    required this.name,
    required this.emoji,
    required this.layers,
    this.disabled = false,
  });
}

class PackedItemPosition {
  final PackingItemModel item;
  final int layer;
  final int quadrant;

  PackedItemPosition({
    required this.item,
    required this.layer,
    required this.quadrant,
  });
}
