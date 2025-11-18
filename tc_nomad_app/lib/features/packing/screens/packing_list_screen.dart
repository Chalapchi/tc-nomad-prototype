import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../services/subscription_service.dart';
import '../widgets/packing_category_section.dart';
import '../widgets/add_item_modal.dart';
import '../../visual_guide/screens/visual_packing_guide_screen.dart';
import '../../subscription/screens/paywall_screen.dart';

/// Smart Packing List Screen
/// AI-generated packing list with categories
/// Based on tc-nomad-step1-wireframe.html
class PackingListScreen extends StatefulWidget {
  final Map<String, dynamic> tripData;

  const PackingListScreen({
    super.key,
    required this.tripData,
  });

  @override
  State<PackingListScreen> createState() => _PackingListScreenState();
}

class _PackingListScreenState extends State<PackingListScreen> {
  bool _isGenerating = true;
  late List<PackingCategory> _categories;

  @override
  void initState() {
    super.initState();
    _generatePackingList();
  }

  Future<void> _generatePackingList() async {
    setState(() => _isGenerating = true);

    // Simulate AI generation
    await Future.delayed(const Duration(seconds: 2));

    // Mock AI-generated packing list based on trip data
    _categories = _getMockPackingList();

    setState(() => _isGenerating = false);
  }

  Future<void> _handleRegenerate() async {
    if (!SubscriptionService.canGenerateAiList()) {
      // Show paywall when AI generation limit is reached
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const PaywallScreen(canDismiss: true),
        ),
      );
      return;
    }

    // Track AI generation usage
    SubscriptionService.incrementAiGenerations();

    // Regenerate the packing list
    await _generatePackingList();
  }

  List<PackingCategory> _getMockPackingList() {
    final tripType = widget.tripData['tripType'] as String? ?? 'Business Trip';
    final activities = widget.tripData['activities'] as List<String>? ?? [];

    // Base categories
    final categories = <PackingCategory>[];

    // Business Attire (if business trip or business meetings)
    if (tripType == 'Business Trip' || activities.contains('Business Meetings')) {
      categories.add(PackingCategory(
        name: 'Business Attire',
        emoji: '👔',
        items: [
          PackingItemModel(id: '1', name: 'Business Shirts', emoji: '👔', quantity: 3, isPacked: false),
          PackingItemModel(id: '2', name: 'Dress Pants', emoji: '👖', quantity: 2, isPacked: false),
          PackingItemModel(id: '3', name: 'Business Shoes', emoji: '👞', quantity: 1, isPacked: false),
          PackingItemModel(id: '4', name: 'Blazer', emoji: '🧥', quantity: 1, isPacked: false),
        ],
      ));
    }

    // Casual Wear
    categories.add(PackingCategory(
      name: 'Casual Wear',
      emoji: '👕',
      items: [
        PackingItemModel(id: '5', name: 'T-Shirts', emoji: '👕', quantity: 4, isPacked: false),
        PackingItemModel(id: '6', name: 'Casual Pants', emoji: '👖', quantity: 2, isPacked: false),
        PackingItemModel(id: '7', name: 'Underwear', emoji: '🩲', quantity: 5, isPacked: false),
        PackingItemModel(id: '8', name: 'Socks', emoji: '🧦', quantity: 5, isPacked: false),
      ],
    ));

    // Weather Gear
    categories.add(PackingCategory(
      name: 'Weather Gear',
      emoji: '🌦️',
      items: [
        PackingItemModel(id: '9', name: 'Rain Jacket', emoji: '🧥', quantity: 1, isPacked: false),
        PackingItemModel(id: '10', name: 'Warm Sweater', emoji: '🧶', quantity: 2, isPacked: false),
        PackingItemModel(id: '11', name: 'Umbrella', emoji: '☂️', quantity: 1, isPacked: false),
      ],
    ));

    // Toiletries
    categories.add(PackingCategory(
      name: 'Toiletries',
      emoji: '🧴',
      items: [
        PackingItemModel(id: '12', name: 'Toiletry Bag', emoji: '💼', quantity: 1, isPacked: false),
        PackingItemModel(id: '13', name: 'Toothbrush & Paste', emoji: '🪥', quantity: 1, isPacked: false),
        PackingItemModel(id: '14', name: 'Shampoo', emoji: '🧴', quantity: 1, isPacked: false),
        PackingItemModel(id: '15', name: 'Deodorant', emoji: '🧴', quantity: 1, isPacked: false),
      ],
    ));

    // Electronics
    categories.add(PackingCategory(
      name: 'Electronics',
      emoji: '📱',
      items: [
        PackingItemModel(id: '16', name: 'Phone Charger', emoji: '🔌', quantity: 1, isPacked: false),
        PackingItemModel(id: '17', name: 'Laptop', emoji: '💻', quantity: 1, isPacked: false),
        PackingItemModel(id: '18', name: 'Power Bank', emoji: '🔋', quantity: 1, isPacked: false),
      ],
    ));

    // Documents
    categories.add(PackingCategory(
      name: 'Documents',
      emoji: '📄',
      items: [
        PackingItemModel(id: '19', name: 'Passport', emoji: '📘', quantity: 1, isPacked: false),
        PackingItemModel(id: '20', name: 'Boarding Pass', emoji: '🎫', quantity: 1, isPacked: false),
        PackingItemModel(id: '21', name: 'Travel Insurance', emoji: '📄', quantity: 1, isPacked: false),
      ],
    ));

    return categories;
  }

  int get _totalItems {
    return _categories.fold(0, (sum, cat) => sum + cat.items.length);
  }

  int get _packedItems {
    return _categories.fold(0, (sum, cat) =>
      sum + cat.items.where((item) => item.isPacked).length);
  }

  double get _packingProgress {
    return _totalItems > 0 ? _packedItems / _totalItems : 0.0;
  }

  void _handleItemToggle(String categoryName, String itemId) {
    setState(() {
      final category = _categories.firstWhere((cat) => cat.name == categoryName);
      final item = category.items.firstWhere((item) => item.id == itemId);
      item.isPacked = !item.isPacked;
    });
  }

  void _handleQuantityChange(String categoryName, String itemId, int delta) {
    setState(() {
      final category = _categories.firstWhere((cat) => cat.name == categoryName);
      final item = category.items.firstWhere((item) => item.id == itemId);
      item.quantity = (item.quantity + delta).clamp(0, 99);
      if (item.quantity == 0) {
        item.isPacked = false;
      }
    });
  }

  void _handleRemoveItem(String categoryName, String itemId) {
    setState(() {
      final category = _categories.firstWhere((cat) => cat.name == categoryName);
      category.items.removeWhere((item) => item.id == itemId);
    });
  }

  void _handleAddCustomItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddItemModal(
        onAdd: (categoryName, itemName) {
          setState(() {
            final category = _categories.firstWhere(
              (cat) => cat.name == categoryName,
              orElse: () {
                final newCat = PackingCategory(
                  name: 'Miscellaneous',
                  emoji: '📦',
                  items: [],
                );
                _categories.add(newCat);
                return newCat;
              },
            );
            category.items.add(PackingItemModel(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: itemName,
              emoji: '📦',
              quantity: 1,
              isPacked: false,
              isCustom: true,
            ));
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isGenerating) {
      return _buildGeneratingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Packing List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _handleRegenerate,
            tooltip: 'Regenerate',
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Section
          _buildProgressSection(),

          // Packing List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              children: [
                ..._categories.map((category) => PackingCategorySection(
                  category: category,
                  onItemToggle: _handleItemToggle,
                  onQuantityChange: _handleQuantityChange,
                  onRemoveItem: _handleRemoveItem,
                )),

                const SizedBox(height: AppConstants.spacingMd),

                // Add Custom Item Button
                GestureDetector(
                  onTap: _handleAddCustomItem,
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.spacingMd),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.add_circle_outline, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Add Custom Item',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: AppConstants.spacingXl),
              ],
            ),
          ),

          // Continue Button
          Container(
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
                text: 'Continue to Visual Packing Guide',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => VisualPackingGuideScreen(
                        tripData: widget.tripData,
                        packingList: _categories,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneratingScreen() {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: AppConstants.spacingXl),
              Text(
                'Generating Your\nPacking List',
                style: AppTextStyles.displayMedium.copyWith(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.spacingMd),
              Text(
                'AI is analyzing your trip details...',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
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
                  'Packing Progress',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white),
                ),
                Text(
                  '${(_packingProgress * 100).toInt()}%',
                  style: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
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
                minHeight: 8,
              ),
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_packedItems of $_totalItems items packed',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                Text(
                  widget.tripData['destination'] ?? 'Your Trip',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Models
class PackingCategory {
  final String name;
  final String emoji;
  final List<PackingItemModel> items;

  PackingCategory({
    required this.name,
    required this.emoji,
    required this.items,
  });
}

class PackingItemModel {
  final String id;
  final String name;
  final String emoji;
  int quantity;
  bool isPacked;
  final bool isCustom;

  PackingItemModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.quantity,
    required this.isPacked,
    this.isCustom = false,
  });
}
