import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../luggage/screens/luggage_list_screen.dart';
import '../../luggage/screens/luggage_creation_screen.dart';

/// Step 3: Luggage Selection
/// Select from saved luggage profiles or create new
class LuggageStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final Map<String, dynamic> tripData;

  const LuggageStep({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.tripData,
  });

  @override
  State<LuggageStep> createState() => _LuggageStepState();
}

class _LuggageStepState extends State<LuggageStep> {
  List<String> _selectedLuggageIds = [];

  // Mock luggage data (replace with actual data from provider)
  final List<Map<String, dynamic>> _mockLuggage = [
    {
      'id': '1',
      'name': 'Black Carry-On',
      'emoji': '🧳',
      'specs': '24" × 16" × 10" • 58L capacity',
      'isDefault': true,
      'type': 'carry-on',
      'dimensions': {'length': 55.0, 'width': 40.0, 'height': 23.0},
    },
    {
      'id': '2',
      'name': 'Personal Backpack',
      'emoji': '🎒',
      'specs': '18" × 13" × 8" • 20L capacity',
      'isDefault': false,
      'type': 'backpack',
      'dimensions': {'length': 45.0, 'width': 32.0, 'height': 20.0},
    },
    {
      'id': '3',
      'name': 'Leather Briefcase',
      'emoji': '💼',
      'specs': '17" × 12" × 6" • 12L capacity',
      'isDefault': false,
      'type': 'briefcase',
      'dimensions': {'length': 43.0, 'width': 30.0, 'height': 15.0},
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.tripData['luggageIds'] != null) {
      _selectedLuggageIds = List<String>.from(widget.tripData['luggageIds']);
    }

    // Auto-select first two luggages if none selected (carry-on and backpack)
    if (_selectedLuggageIds.isEmpty && _mockLuggage.length >= 2) {
      _selectedLuggageIds.add(_mockLuggage[0]['id'] as String);
      _selectedLuggageIds.add(_mockLuggage[1]['id'] as String);
    }
  }

  void _handleNext() {
    if (_selectedLuggageIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one luggage'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    widget.tripData['luggageIds'] = _selectedLuggageIds;
    // Also pass the full luggage objects for the next screens to use
    widget.tripData['selectedLuggages'] = _mockLuggage
        .where((l) => _selectedLuggageIds.contains(l['id']))
        .toList();
        
    widget.onNext();
  }

  void _handleAddLuggage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LuggageCreationScreen(),
      ),
    );

    if (result != null) {
      // Luggage was created, add to list and select it
      setState(() {
        _mockLuggage.add({
          'id': result['id'],
          'name': result['name'],
          'emoji': _getEmojiForType(result['type']),
          'specs': _getSpecsString(result),
          'isDefault': result['isDefault'],
          'type': result['type'],
          'dimensions': result['dimensions'],
        });
        if (!_selectedLuggageIds.contains(result['id'])) {
          _selectedLuggageIds.add(result['id']);
        }
      });
    }
  }

  void _handleBrowseLuggage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LuggageListScreen(isSelectionMode: true),
      ),
    );

    if (result != null) {
      setState(() {
        final id = result['id'];
        if (!_selectedLuggageIds.contains(id)) {
          _selectedLuggageIds.add(id);
        }
      });
    }
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedLuggageIds.contains(id)) {
        _selectedLuggageIds.remove(id);
      } else {
        _selectedLuggageIds.add(id);
      }
    });
  }

  String _getEmojiForType(String type) {
    switch (type) {
      case 'carry-on':
        return '🧳';
      case 'checked':
        return '🧳';
      case 'backpack':
        return '🎒';
      case 'briefcase':
        return '💼';
      case 'duffel':
        return '👜';
      case 'personal':
        return '👝';
      default:
        return '🧳';
    }
  }

  String _getSpecsString(Map<String, dynamic> luggage) {
    final dims = luggage['dimensions'];
    final capacity = _calculateCapacity(dims['length'], dims['width'], dims['height']);
    return '${dims['length']}×${dims['width']}×${dims['height']} cm • ${capacity.toStringAsFixed(1)}L capacity';
  }

  double _calculateCapacity(double length, double width, double height) {
    return (length * width * height) / 1000; // Convert cm³ to liters
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            children: [
              Text(
                'Choose Your Luggage',
                style: AppTextStyles.headlineLarge,
              ),
              const SizedBox(height: AppConstants.spacingSm),
              Text(
                'Select one or more bags for this trip',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: AppConstants.spacingLg),

              // Luggage List
              ..._mockLuggage.map((luggage) {
                final id = luggage['id'] as String;
                final isSelected = _selectedLuggageIds.contains(id);

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppConstants.spacingMd),
                  child: GestureDetector(
                    onTap: () => _toggleSelection(id),
                    child: Container(
                      padding: const EdgeInsets.all(AppConstants.spacingMd),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.border,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      ),
                      child: Row(
                        children: [
                          // Emoji Icon
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                            ),
                            child: Center(
                              child: Text(
                                luggage['emoji'] as String,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingMd),

                          // Luggage Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      luggage['name'] as String,
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    if (luggage['isDefault'] as bool) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.success.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'DEFAULT',
                                          style: AppTextStyles.labelSmall.copyWith(
                                            color: AppColors.success,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  luggage['specs'] as String,
                                  style: AppTextStyles.bodySmall,
                                ),
                              ],
                            ),
                          ),

                          // Selection Indicator
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.border,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),

              // Add New Luggage Button
              GestureDetector(
                onTap: _handleAddLuggage,
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
                      const Icon(
                        Icons.add_circle_outline,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppConstants.spacingSm),
                      Text(
                        'Add New Luggage',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingMd),

              // Browse All Luggage Button
              GestureDetector(
                onTap: _handleBrowseLuggage,
                child: Container(
                  padding: const EdgeInsets.all(AppConstants.spacingMd),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.luggage,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppConstants.spacingSm),
                      Text(
                        'Browse All Luggage',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        // Navigation Buttons
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
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onBack,
                    child: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  flex: 2,
                  child: GradientButton(
                    text: 'Continue',
                    onPressed: _handleNext,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
