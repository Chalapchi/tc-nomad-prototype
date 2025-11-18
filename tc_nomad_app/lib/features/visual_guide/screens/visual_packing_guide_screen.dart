import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../packing/screens/packing_list_screen.dart';

/// Visual Packing Guide Screen
/// Interactive packing with compartments (NO layers/quadrants)
/// Based on tc-nomad-step2a-compartments.html wireframe
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
  final Map<String, List<PackedItem>> _packedItems = {};

  final List<CompartmentInfo> _compartments = [
    CompartmentInfo(
      id: 'main',
      name: 'Main Compartment',
      emoji: '📦',
      capacity: 18.0,
    ),
    CompartmentInfo(
      id: 'front',
      name: 'Front Pocket',
      emoji: '👝',
      capacity: 2.0,
    ),
    CompartmentInfo(
      id: 'laptop',
      name: 'Laptop Sleeve',
      emoji: '💻',
      capacity: 1.5,
    ),
    CompartmentInfo(
      id: 'side',
      name: 'Side Pocket',
      emoji: '📂',
      capacity: 0.5,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize packed items map
    for (var comp in _compartments) {
      _packedItems[comp.id] = [];
    }
    // Auto-assign items to main compartment
    _autoAssignItems();
  }

  void _autoAssignItems() {
    final allItems = widget.packingList.expand((cat) => cat.items).toList();
    for (var item in allItems) {
      _packedItems['main']!.add(PackedItem(
        item: item,
        packingMethod: _suggestPackingMethod(item.name),
      ));
    }
  }

  String _suggestPackingMethod(String itemName) {
    final lower = itemName.toLowerCase();
    if (lower.contains('shirt') || lower.contains('underwear')) return 'Rolled';
    if (lower.contains('pants') || lower.contains('dress')) return 'Folded';
    if (lower.contains('blazer') || lower.contains('jacket')) return 'Fold carefully';
    if (lower.contains('cable') || lower.contains('charger')) return 'Coiled';
    return 'As is';
  }

  List<PackingItemModel> get _unpackedItems {
    final packed = _packedItems.values.expand((list) => list.map((p) => p.item.id)).toSet();
    return widget.packingList
        .expand((cat) => cat.items)
        .where((item) => !packed.contains(item.id))
        .toList();
  }

  void _packItem(PackingItemModel item, String compartmentId) {
    setState(() {
      _packedItems[compartmentId]!.add(PackedItem(
        item: item,
        packingMethod: _suggestPackingMethod(item.name),
      ));
    });
  }

  void _moveItem(PackedItem packedItem, String fromCompartment, String toCompartment) {
    setState(() {
      _packedItems[fromCompartment]!.remove(packedItem);
      _packedItems[toCompartment]!.add(packedItem);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Moved ${packedItem.item.name} to ${_getCompartmentName(toCompartment)}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _changePackingMethod(PackedItem packedItem, String compartmentId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPackingMethodModal(packedItem, compartmentId),
    );
  }

  String _getCompartmentName(String id) {
    return _compartments.firstWhere((c) => c.id == id).name;
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
              showDialog(
                context: context,
                builder: (context) => _buildHelpDialog(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Info Banner
          _buildInfoBanner(),

          // Luggage Visual
          _buildLuggageVisual(),

          // Compartment Tabs
          _buildCompartmentTabs(),

          // Compartment Items
          Expanded(
            child: _buildCompartmentItems(),
          ),

          // Bottom Summary
          _buildBottomSummary(),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Items have been optimally assigned to compartments. Tap "Move" to reassign.',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLuggageVisual() {
    return GlassCard(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 90,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.border,
                  AppColors.border.withOpacity(0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: const Center(
              child: Text('🧳', style: TextStyle(fontSize: 48)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Standard Carry-on Suitcase',
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            '55×40×23 cm • 22L capacity • ${_compartments.length} compartments',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildCompartmentTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
      child: Row(
        children: _compartments.map((comp) {
          final isSelected = comp.id == _selectedCompartment;
          final itemCount = _packedItems[comp.id]?.length ?? 0;

          return GestureDetector(
            onTap: () => setState(() => _selectedCompartment = comp.id),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        comp.emoji,
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        comp.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$itemCount items',
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected ? Colors.white.withOpacity(0.8) : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCompartmentItems() {
    final items = _packedItems[_selectedCompartment] ?? [];

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: AppColors.textTertiary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No items in this compartment',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Items will appear here when assigned',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final packedItem = items[index];
        return _buildPackedItemCard(packedItem);
      },
    );
  }

  Widget _buildPackedItemCard(PackedItem packedItem) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Drag Handle
            const Icon(Icons.drag_indicator, color: AppColors.border),
            const SizedBox(width: 12),

            // Item Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  packedItem.item.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Item Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    packedItem.item.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      // Packing Method Chip
                      GestureDetector(
                        onTap: () => _changePackingMethod(packedItem, _selectedCompartment),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                packedItem.packingMethod,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.edit,
                                size: 12,
                                color: AppColors.success,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_estimateVolume(packedItem.item.name)}L',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Move Button
            TextButton(
              onPressed: () => _showMoveDialog(packedItem),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                backgroundColor: AppColors.surface,
              ),
              child: Text(
                'Move',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoveDialog(PackedItem packedItem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(AppConstants.spacingLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Move ${packedItem.item.name}',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 16),
            ..._compartments.where((c) => c.id != _selectedCompartment).map((comp) {
              return ListTile(
                leading: Text(comp.emoji, style: const TextStyle(fontSize: 24)),
                title: Text(comp.name),
                subtitle: Text('${_packedItems[comp.id]?.length ?? 0} items'),
                onTap: () {
                  Navigator.pop(context);
                  _moveItem(packedItem, _selectedCompartment, comp.id);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPackingMethodModal(PackedItem packedItem, String compartmentId) {
    final methods = ['Rolled', 'Folded', 'Fold carefully', 'Coiled', 'As is', 'Compressed'];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Packing Method',
            style: AppTextStyles.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            packedItem.item.name,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: methods.map((method) {
              final isSelected = method == packedItem.packingMethod;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    packedItem.packingMethod = method;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    method,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          GradientButton(
            text: 'Done',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSummary() {
    final totalItems = _packedItems.values.fold<int>(
      0,
      (sum, list) => sum + list.length,
    );

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'All $totalItems items assigned to compartments',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            GradientButton(
              text: 'Complete Packing Guide',
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpDialog() {
    return AlertDialog(
      title: const Text('Visual Packing Guide'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('How to use this guide:'),
          const SizedBox(height: 12),
          _buildHelpItem('1', 'Select a compartment from the tabs'),
          _buildHelpItem('2', 'View items assigned to that compartment'),
          _buildHelpItem('3', 'Tap packing method chips to change how to pack'),
          _buildHelpItem('4', 'Tap "Move" to reassign items to other compartments'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.lightbulb_outline, color: AppColors.info, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Items are AI-assigned for optimal packing',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Got it'),
        ),
      ],
    );
  }

  Widget _buildHelpItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  double _estimateVolume(String itemName) {
    final lower = itemName.toLowerCase();
    if (lower.contains('shirt')) return 0.8;
    if (lower.contains('pants')) return 1.2;
    if (lower.contains('underwear')) return 0.1;
    if (lower.contains('blazer') || lower.contains('jacket')) return 2.5;
    if (lower.contains('toiletries')) return 0.5;
    if (lower.contains('charger') || lower.contains('cable')) return 0.3;
    return 0.5;
  }
}

// Data Models
class CompartmentInfo {
  final String id;
  final String name;
  final String emoji;
  final double capacity;

  CompartmentInfo({
    required this.id,
    required this.name,
    required this.emoji,
    required this.capacity,
  });
}

class PackedItem {
  final PackingItemModel item;
  String packingMethod;

  PackedItem({
    required this.item,
    required this.packingMethod,
  });
}
