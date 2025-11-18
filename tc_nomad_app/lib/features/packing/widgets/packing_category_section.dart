import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../screens/packing_list_screen.dart';

/// Packing Category Section
/// Collapsible section for each category with items
class PackingCategorySection extends StatefulWidget {
  final PackingCategory category;
  final Function(String categoryName, String itemId) onItemToggle;
  final Function(String categoryName, String itemId, int delta) onQuantityChange;
  final Function(String categoryName, String itemId) onRemoveItem;

  const PackingCategorySection({
    super.key,
    required this.category,
    required this.onItemToggle,
    required this.onQuantityChange,
    required this.onRemoveItem,
  });

  @override
  State<PackingCategorySection> createState() => _PackingCategorySectionState();
}

class _PackingCategorySectionState extends State<PackingCategorySection> {
  bool _isExpanded = true;

  int get _packedCount {
    return widget.category.items.where((item) => item.isPacked).length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            child: Container(
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              child: Row(
                children: [
                  // Emoji
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        widget.category.emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMd),

                  // Category Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.category.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$_packedCount/${widget.category.items.length} packed',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),

                  // Expand Icon
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textTertiary,
                  ),
                ],
              ),
            ),
          ),

          // Items
          if (_isExpanded)
            ...widget.category.items.map((item) => _buildPackingItem(item)),
        ],
      ),
    );
  }

  Widget _buildPackingItem(PackingItemModel item) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMd,
        vertical: AppConstants.spacingSm,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () => widget.onItemToggle(widget.category.name, item.id),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: item.isPacked ? AppColors.success : Colors.transparent,
                border: Border.all(
                  color: item.isPacked ? AppColors.success : AppColors.border,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: item.isPacked
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMd),

          // Item Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(item.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          decoration: item.isPacked
                              ? TextDecoration.lineThrough
                              : null,
                          color: item.isPacked
                              ? AppColors.textTertiary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    if (item.isCustom)
                      Container(
                        margin: const EdgeInsets.only(left: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'CUSTOM',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.info,
                            fontSize: 8,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Quantity Controls
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildQuantityButton(
                  Icons.remove,
                  () => widget.onQuantityChange(widget.category.name, item.id, -1),
                  enabled: item.quantity > 0,
                ),
                Container(
                  width: 32,
                  alignment: Alignment.center,
                  child: Text(
                    '${item.quantity}',
                    style: AppTextStyles.labelMedium,
                  ),
                ),
                _buildQuantityButton(
                  Icons.add,
                  () => widget.onQuantityChange(widget.category.name, item.id, 1),
                  enabled: item.quantity < 99,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.spacingSm),

          // Remove Button
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Remove Item?'),
                  content: Text('Remove "${item.name}" from packing list?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onRemoveItem(widget.category.name, item.id);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                      ),
                      child: const Text('Remove'),
                    ),
                  ],
                ),
              );
            },
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.delete_outline,
                size: 16,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onTap, {bool enabled = true}) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: enabled ? Colors.white : AppColors.background,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? AppColors.primary : AppColors.textDisabled,
        ),
      ),
    );
  }
}
