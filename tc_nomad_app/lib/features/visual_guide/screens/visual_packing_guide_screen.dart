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
  String _selectedLuggageId = '1'; // Default to carry-on
  String _selectedCompartment = 'main';
  final Map<String, Map<String, List<PackedItem>>> _packedItems = {}; // luggageId -> compartmentId -> items

  // Define luggage-specific compartments
  final Map<String, List<CompartmentInfo>> _luggageCompartments = {
    '1': [ // Carry-on
      CompartmentInfo(
        id: 'main',
        name: 'Main Compartment',
        emoji: '📦',
        capacity: 45.0,
      ),
      CompartmentInfo(
        id: 'front',
        name: 'Front Zippered Pocket',
        emoji: '👝',
        capacity: 10.0,
      ),
      CompartmentInfo(
        id: 'divider',
        name: 'Internal Divider Pocket',
        emoji: '📂',
        capacity: 3.0,
      ),
    ],
    '2': [ // Backpack
      CompartmentInfo(
        id: 'main',
        name: 'Main Compartment',
        emoji: '📦',
        capacity: 12.0,
      ),
      CompartmentInfo(
        id: 'quick',
        name: 'Quick Access Pocket',
        emoji: '👝',
        capacity: 1.0,
      ),
    ],
    '3': [ // Briefcase
      CompartmentInfo(
        id: 'main',
        name: 'Main Compartment',
        emoji: '📦',
        capacity: 8.0,
      ),
    ],
  };

  // Get current luggage info from tripData
  List<Map<String, dynamic>> get _selectedLuggages {
    return (widget.tripData['selectedLuggages'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
  }

  List<CompartmentInfo> get _currentCompartments {
    return _luggageCompartments[_selectedLuggageId] ?? [];
  }

  @override
  void initState() {
    super.initState();
    // Initialize packed items map for all luggages and compartments
    for (var luggageId in _luggageCompartments.keys) {
      _packedItems[luggageId] = {};
      for (var comp in _luggageCompartments[luggageId]!) {
        _packedItems[luggageId]![comp.id] = [];
      }
    }
    // Auto-assign items to appropriate luggages
    _autoAssignItems();
  }

  void _autoAssignItems() {
    final allItems = widget.packingList.expand((cat) => cat.items).toList();

    for (var item in allItems) {
      final itemName = item.name.toLowerCase();
      String targetLuggage = '1'; // Default to carry-on
      String targetCompartment = 'main';

      // Smart assignment based on item type
      if (itemName.contains('laptop') || itemName.contains('tablet') ||
          itemName.contains('document') || itemName.contains('headphone')) {
        // Electronics and documents go to backpack
        targetLuggage = '2';
        targetCompartment = itemName.contains('headphone') || itemName.contains('key') ? 'quick' : 'main';
      } else if (itemName.contains('presentation') || itemName.contains('business card') ||
                 itemName.contains('pen') || itemName.contains('notebook')) {
        // Business items go to briefcase
        targetLuggage = '3';
        targetCompartment = 'main';
      } else if (itemName.contains('shirt') || itemName.contains('pants') ||
                 itemName.contains('blazer') || itemName.contains('dress')) {
        // Clothing goes to carry-on main compartment
        targetLuggage = '1';
        targetCompartment = 'main';
      } else if (itemName.contains('toiletries') || itemName.contains('charger')) {
        // Toiletries and chargers to carry-on front pocket
        targetLuggage = '1';
        targetCompartment = 'front';
      } else if (itemName.contains('underwear') || itemName.contains('sock')) {
        // Undergarments to carry-on divider pocket
        targetLuggage = '1';
        targetCompartment = 'divider';
      }

      // Only add if the luggage has that compartment
      if (_packedItems.containsKey(targetLuggage) &&
          _packedItems[targetLuggage]!.containsKey(targetCompartment)) {
        _packedItems[targetLuggage]![targetCompartment]!.add(PackedItem(
          item: item,
          packingMethod: _suggestPackingMethod(item.name),
        ));
      } else {
        // Fallback to carry-on main if compartment doesn't exist
        _packedItems['1']!['main']!.add(PackedItem(
          item: item,
          packingMethod: _suggestPackingMethod(item.name),
        ));
      }
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
    final packed = _packedItems.values
        .expand((compartments) => compartments.values)
        .expand((list) => list.map((p) => p.item.id))
        .toSet();
    return widget.packingList
        .expand((cat) => cat.items)
        .where((item) => !packed.contains(item.id))
        .toList();
  }

  void _packItem(PackingItemModel item, String compartmentId) {
    setState(() {
      _packedItems[_selectedLuggageId]![compartmentId]!.add(PackedItem(
        item: item,
        packingMethod: _suggestPackingMethod(item.name),
      ));
    });
  }

  void _moveItem(PackedItem packedItem, String fromCompartment, String toCompartment) {
    setState(() {
      _packedItems[_selectedLuggageId]![fromCompartment]!.remove(packedItem);
      _packedItems[_selectedLuggageId]![toCompartment]!.add(packedItem);
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
    return _currentCompartments.firstWhere((c) => c.id == id).name;
  }

  Map<String, dynamic>? _getCurrentLuggageData() {
    return _selectedLuggages.firstWhere(
      (luggage) => luggage['id'] == _selectedLuggageId,
      orElse: () => _selectedLuggages.isNotEmpty ? _selectedLuggages[0] : {},
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

          // Luggage Tabs (show if multiple luggages selected)
          if (_selectedLuggages.length > 1) _buildLuggageTabs(),

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

  Widget _buildLuggageTabs() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd, vertical: AppConstants.spacingSm),
      color: AppColors.surface,
      child: Row(
        children: _selectedLuggages.map((luggage) {
          final luggageId = luggage['id'] as String;
          final isSelected = luggageId == _selectedLuggageId;
          final totalItems = _packedItems[luggageId]?.values.fold<int>(0, (sum, list) => sum + list.length) ?? 0;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedLuggageId = luggageId;
                  _selectedCompartment = 'main'; // Reset to main compartment
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      luggage['emoji'] as String,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      luggage['name'] as String,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$totalItems items',
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        color: isSelected ? Colors.white.withOpacity(0.8) : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
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
    final currentLuggage = _getCurrentLuggageData();
    final luggageName = currentLuggage?['name'] as String? ?? 'Luggage';
    final luggageEmoji = currentLuggage?['emoji'] as String? ?? '🧳';
    final luggageSpecs = currentLuggage?['specs'] as String? ?? '';
    final compartmentCount = _currentCompartments.length;

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
            child: Center(
              child: Text(luggageEmoji, style: const TextStyle(fontSize: 48)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            luggageName,
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            '$luggageSpecs • $compartmentCount compartments',
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
        children: _currentCompartments.map((comp) {
          final isSelected = comp.id == _selectedCompartment;
          final itemCount = _packedItems[_selectedLuggageId]?[comp.id]?.length ?? 0;

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
    final items = _packedItems[_selectedLuggageId]?[_selectedCompartment] ?? [];

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
            ..._currentCompartments.where((c) => c.id != _selectedCompartment).map((comp) {
              return ListTile(
                leading: Text(comp.emoji, style: const TextStyle(fontSize: 24)),
                title: Text(comp.name),
                subtitle: Text('${_packedItems[_selectedLuggageId]?[comp.id]?.length ?? 0} items'),
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
    final totalItems = _packedItems.values
        .expand((compartments) => compartments.values)
        .fold<int>(0, (sum, list) => sum + list.length);

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
