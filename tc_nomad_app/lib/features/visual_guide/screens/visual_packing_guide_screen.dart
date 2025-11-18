import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../packing/screens/packing_list_screen.dart';

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

  final List<CompartmentInfo> _compartments = [
    CompartmentInfo(id: 'main', name: 'Main Compartment', emoji: '📦', layers: 3),
    CompartmentInfo(id: 'front', name: 'Front Pocket', emoji: '👝', layers: 1),
    CompartmentInfo(id: 'laptop', name: 'Laptop Sleeve', emoji: '💻', layers: 1, disabled: true),
    CompartmentInfo(id: 'side', name: 'Side Pocket', emoji: '📂', layers: 1, disabled: true),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize packed items map
    for (var comp in _compartments) {
      _packedItems[comp.id] = [];
    }
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

  void _packItem(PackingItemModel item) {
    setState(() {
      // Add item to current compartment
      _packedItems[_selectedCompartment]!.add(PackedItemPosition(
        item: item,
        layer: 1,
        quadrant: 1,
      ));
      // Mark as packed
      item.isPacked = true;
    });

    // Show flying animation
    _showPackingAnimation(item);
  }

  void _showPackingAnimation(PackingItemModel item) {
    // TODO: Implement flying emoji animation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.emoji} ${item.name} packed!'),
        duration: const Duration(seconds: 1),
        backgroundColor: AppColors.success,
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
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // TODO: Show packing tips
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Stage Indicator
          _buildStageIndicator(),

          // Compartment Tabs
          _buildCompartmentTabs(),

          // Visual Packing Area
          Expanded(
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

          // Complete Button
          _buildCompleteButton(),
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
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Luggage Icon
          Text(
            '🧳',
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: AppConstants.spacingMd),

          // Packed Items Display
          if (compartmentItems.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: compartmentItems.map((packed) {
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    packed.item.emoji,
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              }).toList(),
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
          Text(
            'Pack into $compartmentName',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: AppConstants.spacingMd),
          Expanded(
            child: ListView(
              children: _unpackedItems.take(5).map((item) {
                return ListTile(
                  leading: Text(item.emoji, style: const TextStyle(fontSize: 24)),
                  title: Text(item.name, style: AppTextStyles.bodyMedium),
                  subtitle: Text(
                    'Qty: ${item.quantity} • Tap to pack',
                    style: AppTextStyles.caption,
                  ),
                  trailing: const Icon(Icons.touch_app, color: AppColors.primary),
                  onTap: () => _packItem(item),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                  tileColor: AppColors.background,
                );
              }).toList(),
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
