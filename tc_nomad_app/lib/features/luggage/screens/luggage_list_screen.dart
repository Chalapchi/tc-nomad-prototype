import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/glass_card.dart';
import 'luggage_creation_screen.dart';

/// Luggage List Screen
/// Displays saved luggage profiles with options to add, edit, delete
class LuggageListScreen extends StatefulWidget {
  final bool isSelectionMode; // true when selecting for trip

  const LuggageListScreen({
    super.key,
    this.isSelectionMode = false,
  });

  @override
  State<LuggageListScreen> createState() => _LuggageListScreenState();
}

class _LuggageListScreenState extends State<LuggageListScreen> {
  // Mock luggage data (will be replaced with Hive/Riverpod)
  final List<Map<String, dynamic>> _luggageList = [
    {
      'id': '1',
      'name': 'My Carry-On',
      'type': 'carry-on',
      'emoji': '🧳',
      'color': 'black',
      'colorValue': Colors.black,
      'dimensions': {'length': 55.0, 'width': 40.0, 'height': 23.0},
      'weight': 7.0,
      'capacity': 40.0,
      'compartments': {'main': true, 'front': true, 'laptop': true, 'side': false},
      'hasWheels': true,
      'isDefault': true,
    },
    {
      'id': '2',
      'name': 'Travel Backpack',
      'type': 'backpack',
      'emoji': '🎒',
      'color': 'navy',
      'colorValue': Color(0xFF001f3f),
      'dimensions': {'length': 50.0, 'width': 30.0, 'height': 20.0},
      'weight': 1.5,
      'capacity': 30.0,
      'compartments': {'main': true, 'front': true, 'laptop': true, 'side': true},
      'hasWheels': false,
      'isDefault': false,
    },
  ];

  void _addLuggage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LuggageCreationScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        // Add new luggage to list
        // TODO: Save to Hive
      });
    }
  }

  void _editLuggage(String luggageId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LuggageCreationScreen(luggageId: luggageId),
      ),
    );

    if (result != null) {
      setState(() {
        // Update luggage in list
        // TODO: Update in Hive
      });
    }
  }

  void _deleteLuggage(String luggageId, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        ),
        title: const Text('Delete Luggage?'),
        content: Text('Are you sure you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _luggageList.removeWhere((l) => l['id'] == luggageId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$name deleted'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _selectLuggage(Map<String, dynamic> luggage) {
    if (widget.isSelectionMode) {
      Navigator.pop(context, luggage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelectionMode ? 'Select Luggage' : 'My Luggage'),
      ),
      body: _luggageList.isEmpty
          ? _buildEmptyState()
          : ListView.separated(
              padding: const EdgeInsets.all(AppConstants.spacingLg),
              itemCount: _luggageList.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: AppConstants.spacingMd),
              itemBuilder: (context, index) {
                final luggage = _luggageList[index];
                return _buildLuggageCard(luggage);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addLuggage,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Add Luggage'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('🧳', style: TextStyle(fontSize: 60)),
              ),
            ),
            const SizedBox(height: AppConstants.spacingXl),
            Text(
              'No Luggage Yet',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: AppConstants.spacingMd),
            Text(
              'Add your luggage to get personalized packing recommendations',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingXl),
            GradientButton(
              text: 'Add Your First Luggage',
              onPressed: _addLuggage,
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLuggageCard(Map<String, dynamic> luggage) {
    final dimensions = luggage['dimensions'] as Map<String, dynamic>;
    final compartments = luggage['compartments'] as Map<String, dynamic>;
    final isDefault = luggage['isDefault'] as bool;

    return GestureDetector(
      onTap: () => _selectLuggage(luggage),
      child: GlassCard(
        child: Container(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Emoji and color indicator
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: luggage['colorValue'],
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    ),
                    child: Center(
                      child: Text(
                        luggage['emoji'],
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMd),
                  // Name and type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                luggage['name'],
                                style: AppTextStyles.headlineSmall,
                              ),
                            ),
                            if (isDefault)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Default',
                                      style: AppTextStyles.labelSmall.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getLuggageTypeName(luggage['type']),
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  // Menu button
                  if (!widget.isSelectionMode)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      ),
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editLuggage(luggage['id']);
                        } else if (value == 'delete') {
                          _deleteLuggage(luggage['id'], luggage['name']);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: AppColors.error),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: AppColors.error)),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Specifications
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
                child: Column(
                  children: [
                    // Dimensions
                    Row(
                      children: [
                        const Icon(Icons.straighten, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text('Dimensions:', style: AppTextStyles.labelMedium),
                        const SizedBox(width: 8),
                        Text(
                          '${dimensions['length']}×${dimensions['width']}×${dimensions['height']} cm',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    // Weight & Capacity
                    Row(
                      children: [
                        const Icon(Icons.fitness_center, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text('Max Weight:', style: AppTextStyles.labelMedium),
                        const SizedBox(width: 8),
                        Text(
                          '${luggage['weight']} kg',
                          style: AppTextStyles.bodySmall,
                        ),
                        const Spacer(),
                        const Icon(Icons.inventory_2, size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          '${luggage['capacity']}L capacity',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),

              // Compartments
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (compartments['main'] == true)
                    _buildFeatureChip('📦 Main', true),
                  if (compartments['front'] == true)
                    _buildFeatureChip('👝 Front', true),
                  if (compartments['laptop'] == true)
                    _buildFeatureChip('💻 Laptop', true),
                  if (compartments['side'] == true)
                    _buildFeatureChip('📂 Side', true),
                  if (luggage['hasWheels'] == true)
                    _buildFeatureChip('🛞 Wheels', true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(String label, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: active
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: active ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: active ? AppColors.primary : AppColors.textSecondary,
        ),
      ),
    );
  }

  String _getLuggageTypeName(String type) {
    switch (type) {
      case 'carry-on':
        return 'Carry-On Suitcase';
      case 'checked':
        return 'Checked Bag';
      case 'backpack':
        return 'Travel Backpack';
      case 'duffel':
        return 'Duffel Bag';
      case 'personal':
        return 'Personal Item';
      default:
        return 'Luggage';
    }
  }
}
