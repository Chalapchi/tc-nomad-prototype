import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/glass_card.dart';

/// Luggage Creation Screen
/// Allows users to create and configure luggage profiles
class LuggageCreationScreen extends StatefulWidget {
  final String? luggageId; // null for new luggage, ID for editing

  const LuggageCreationScreen({
    super.key,
    this.luggageId,
  });

  @override
  State<LuggageCreationScreen> createState() => _LuggageCreationScreenState();
}

class _LuggageCreationScreenState extends State<LuggageCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String _selectedType = 'carry-on';
  String _selectedColor = 'black';
  bool _hasMainCompartment = true;
  bool _hasFrontPocket = true;
  bool _hasLaptopSleeve = false;
  bool _hasSidePocket = false;
  bool _hasWheels = true;
  bool _isDefault = false;

  final List<LuggageTypeOption> _luggageTypes = [
    LuggageTypeOption(
      id: 'carry-on',
      name: 'Carry-On',
      emoji: '🧳',
      description: 'Small suitcase for overhead bins',
      defaultLength: 55,
      defaultWidth: 40,
      defaultHeight: 23,
      defaultWeight: 7,
      capacity: 40,
    ),
    LuggageTypeOption(
      id: 'checked',
      name: 'Checked Bag',
      emoji: '💼',
      description: 'Large suitcase for checked luggage',
      defaultLength: 75,
      defaultWidth: 50,
      defaultHeight: 30,
      defaultWeight: 23,
      capacity: 80,
    ),
    LuggageTypeOption(
      id: 'backpack',
      name: 'Backpack',
      emoji: '🎒',
      description: 'Travel backpack',
      defaultLength: 50,
      defaultWidth: 30,
      defaultHeight: 20,
      defaultWeight: 1.5,
      capacity: 30,
    ),
    LuggageTypeOption(
      id: 'duffel',
      name: 'Duffel Bag',
      emoji: '👜',
      description: 'Flexible duffel bag',
      defaultLength: 60,
      defaultWidth: 30,
      defaultHeight: 30,
      defaultWeight: 2,
      capacity: 50,
    ),
    LuggageTypeOption(
      id: 'personal',
      name: 'Personal Item',
      emoji: '👝',
      description: 'Small bag or purse',
      defaultLength: 35,
      defaultWidth: 20,
      defaultHeight: 15,
      defaultWeight: 0.5,
      capacity: 20,
    ),
  ];

  final List<ColorOption> _colorOptions = [
    ColorOption(id: 'black', name: 'Black', color: Colors.black),
    ColorOption(id: 'navy', name: 'Navy', color: Color(0xFF001f3f)),
    ColorOption(id: 'gray', name: 'Gray', color: Colors.grey),
    ColorOption(id: 'red', name: 'Red', color: Colors.red),
    ColorOption(id: 'blue', name: 'Blue', color: Colors.blue),
    ColorOption(id: 'green', name: 'Green', color: Colors.green),
  ];

  @override
  void initState() {
    super.initState();
    _loadDefaultValues();
  }

  void _loadDefaultValues() {
    final selectedType = _luggageTypes.firstWhere((t) => t.id == _selectedType);
    _nameController.text = 'My ${selectedType.name}';
    _lengthController.text = selectedType.defaultLength.toString();
    _widthController.text = selectedType.defaultWidth.toString();
    _heightController.text = selectedType.defaultHeight.toString();
    _weightController.text = selectedType.defaultWeight.toString();
  }

  void _updateDefaults(String typeId) {
    final selectedType = _luggageTypes.firstWhere((t) => t.id == typeId);
    _nameController.text = 'My ${selectedType.name}';
    _lengthController.text = selectedType.defaultLength.toString();
    _widthController.text = selectedType.defaultWidth.toString();
    _heightController.text = selectedType.defaultHeight.toString();
    _weightController.text = selectedType.defaultWeight.toString();

    // Update compartment defaults based on type
    setState(() {
      if (typeId == 'carry-on' || typeId == 'checked') {
        _hasWheels = true;
        _hasLaptopSleeve = true;
      } else if (typeId == 'backpack') {
        _hasWheels = false;
        _hasLaptopSleeve = true;
      } else {
        _hasWheels = false;
        _hasLaptopSleeve = false;
      }
    });
  }

  void _saveLuggage() {
    if (!_formKey.currentState!.validate()) return;

    // TODO: Save to Hive/State management
    final luggageData = {
      'id': widget.luggageId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'name': _nameController.text,
      'type': _selectedType,
      'color': _selectedColor,
      'dimensions': {
        'length': double.parse(_lengthController.text),
        'width': double.parse(_widthController.text),
        'height': double.parse(_heightController.text),
      },
      'weight': double.parse(_weightController.text),
      'compartments': {
        'main': _hasMainCompartment,
        'front': _hasFrontPocket,
        'laptop': _hasLaptopSleeve,
        'side': _hasSidePocket,
      },
      'hasWheels': _hasWheels,
      'isDefault': _isDefault,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_nameController.text} saved!'),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context, luggageData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.luggageId == null ? 'Add Luggage' : 'Edit Luggage'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Luggage Type Selection
              Text('Luggage Type', style: AppTextStyles.headlineSmall),
              const SizedBox(height: AppConstants.spacingMd),
              _buildTypeSelector(),
              const SizedBox(height: AppConstants.spacingXl),

              // Name Input
              Text('Luggage Name', style: AppTextStyles.headlineSmall),
              const SizedBox(height: AppConstants.spacingMd),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g., My Carry-On',
                  prefixIcon: const Icon(Icons.label_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter a name' : null,
              ),
              const SizedBox(height: AppConstants.spacingXl),

              // Dimensions
              Text('Dimensions (cm)', style: AppTextStyles.headlineSmall),
              const SizedBox(height: AppConstants.spacingMd),
              Row(
                children: [
                  Expanded(child: _buildDimensionField('Length', _lengthController)),
                  const SizedBox(width: AppConstants.spacingMd),
                  Expanded(child: _buildDimensionField('Width', _widthController)),
                  const SizedBox(width: AppConstants.spacingMd),
                  Expanded(child: _buildDimensionField('Height', _heightController)),
                ],
              ),
              const SizedBox(height: AppConstants.spacingXl),

              // Weight
              Text('Max Weight (kg)', style: AppTextStyles.headlineSmall),
              const SizedBox(height: AppConstants.spacingMd),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'e.g., 7',
                  prefixIcon: const Icon(Icons.fitness_center),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                ),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Please enter weight' : null,
              ),
              const SizedBox(height: AppConstants.spacingXl),

              // Color Selection
              Text('Color', style: AppTextStyles.headlineSmall),
              const SizedBox(height: AppConstants.spacingMd),
              _buildColorSelector(),
              const SizedBox(height: AppConstants.spacingXl),

              // Compartments
              Text('Compartments', style: AppTextStyles.headlineSmall),
              const SizedBox(height: AppConstants.spacingMd),
              _buildCompartmentToggles(),
              const SizedBox(height: AppConstants.spacingXl),

              // Features
              Text('Features', style: AppTextStyles.headlineSmall),
              const SizedBox(height: AppConstants.spacingMd),
              _buildFeatureToggles(),
              const SizedBox(height: AppConstants.spacingXl),

              // Save Button
              GradientButton(
                text: widget.luggageId == null ? 'Create Luggage' : 'Save Changes',
                onPressed: _saveLuggage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _luggageTypes.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppConstants.spacingMd),
        itemBuilder: (context, index) {
          final type = _luggageTypes[index];
          final isSelected = _selectedType == type.id;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedType = type.id);
              _updateDefaults(type.id);
            },
            child: GlassCard(
              child: Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.primaryGradient : null,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      type.emoji,
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: AppConstants.spacingSm),
                    Text(
                      type.name,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${type.capacity}L',
                      style: AppTextStyles.caption.copyWith(
                        color: isSelected
                            ? Colors.white.withOpacity(0.9)
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDimensionField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '0',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Wrap(
      spacing: AppConstants.spacingMd,
      runSpacing: AppConstants.spacingMd,
      children: _colorOptions.map((colorOption) {
        final isSelected = _selectedColor == colorOption.id;
        return GestureDetector(
          onTap: () => setState(() => _selectedColor = colorOption.id),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: colorOption.color,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [],
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCompartmentToggles() {
    return Column(
      children: [
        _buildToggleItem(
          'Main Compartment',
          '📦',
          _hasMainCompartment,
          (value) => setState(() => _hasMainCompartment = value),
          enabled: true, // Always enabled
        ),
        _buildToggleItem(
          'Front Pocket',
          '👝',
          _hasFrontPocket,
          (value) => setState(() => _hasFrontPocket = value),
        ),
        _buildToggleItem(
          'Laptop Sleeve',
          '💻',
          _hasLaptopSleeve,
          (value) => setState(() => _hasLaptopSleeve = value),
        ),
        _buildToggleItem(
          'Side Pocket',
          '📂',
          _hasSidePocket,
          (value) => setState(() => _hasSidePocket = value),
        ),
      ],
    );
  }

  Widget _buildFeatureToggles() {
    return Column(
      children: [
        _buildToggleItem(
          'Has Wheels',
          '🛞',
          _hasWheels,
          (value) => setState(() => _hasWheels = value),
        ),
        _buildToggleItem(
          'Set as Default',
          '⭐',
          _isDefault,
          (value) => setState(() => _isDefault = value),
        ),
      ],
    );
  }

  Widget _buildToggleItem(
    String label,
    String emoji,
    bool value,
    Function(bool) onChanged, {
    bool enabled = true,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
      padding: const EdgeInsets.all(AppConstants.spacingMd),
      decoration: BoxDecoration(
        color: value ? AppColors.primary.withOpacity(0.05) : AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: value ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: AppConstants.spacingMd),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: enabled ? AppColors.textPrimary : AppColors.textDisabled,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}

// Helper Classes
class LuggageTypeOption {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final double defaultLength;
  final double defaultWidth;
  final double defaultHeight;
  final double defaultWeight;
  final double capacity;

  LuggageTypeOption({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.defaultLength,
    required this.defaultWidth,
    required this.defaultHeight,
    required this.defaultWeight,
    required this.capacity,
  });
}

class ColorOption {
  final String id;
  final String name;
  final Color color;

  ColorOption({
    required this.id,
    required this.name,
    required this.color,
  });
}
