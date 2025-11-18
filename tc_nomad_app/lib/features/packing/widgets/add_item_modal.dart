import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/custom_text_field.dart';

/// Add Custom Item Modal
/// Bottom sheet for adding custom packing items
class AddItemModal extends StatefulWidget {
  final Function(String categoryName, String itemName) onAdd;

  const AddItemModal({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddItemModal> createState() => _AddItemModalState();
}

class _AddItemModalState extends State<AddItemModal> {
  final _formKey = GlobalKey<FormState>();
  final _itemNameController = TextEditingController();
  String _selectedCategory = 'Miscellaneous';

  final List<String> _categories = [
    'Business Attire',
    'Casual Wear',
    'Weather Gear',
    'Toiletries',
    'Electronics',
    'Documents',
    'Personal Care',
    'Miscellaneous',
  ];

  @override
  void dispose() {
    _itemNameController.dispose();
    super.dispose();
  }

  void _handleAdd() {
    if (_formKey.currentState!.validate()) {
      widget.onAdd(_selectedCategory, _itemNameController.text.trim());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusXl)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Title
                Text(
                  'Add Custom Item',
                  style: AppTextStyles.headlineMedium,
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Item Name
                CustomTextField(
                  label: 'Item Name',
                  hint: 'e.g., Camera tripod, Sunglasses',
                  controller: _itemNameController,
                  prefixIcon: Icons.label_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter item name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppConstants.spacingMd),

                // Category Selection
                Text(
                  'Category',
                  style: AppTextStyles.labelLarge,
                ),
                const SizedBox(height: AppConstants.spacingSm),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.category_outlined),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      borderSide: const BorderSide(color: AppColors.border, width: 2),
                    ),
                  ),
                  items: _categories.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value!),
                ),
                const SizedBox(height: AppConstants.spacingXl),

                // Add Button
                GradientButton(
                  text: 'Add Item',
                  onPressed: _handleAdd,
                ),
                const SizedBox(height: AppConstants.spacingMd),

                // Cancel Button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
