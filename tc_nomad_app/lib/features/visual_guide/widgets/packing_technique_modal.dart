import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';

/// Packing Technique Tutorial Modal
/// Shows step-by-step instructions for different packing methods
class PackingTechniqueModal extends StatefulWidget {
  const PackingTechniqueModal({super.key});

  @override
  State<PackingTechniqueModal> createState() => _PackingTechniqueModalState();
}

class _PackingTechniqueModalState extends State<PackingTechniqueModal>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<PackingTechnique> _techniques = [
    PackingTechnique(
      name: 'Rolling',
      emoji: '🌀',
      description: 'Best for casual wear and wrinkle-resistant fabrics',
      benefits: [
        'Saves space',
        'Minimizes wrinkles',
        'Easy to see items',
        'Great for t-shirts, jeans, and casual wear',
      ],
      steps: [
        'Lay the garment flat on a surface',
        'Fold in the sleeves or sides',
        'Start from the bottom and roll tightly',
        'Secure with a rubber band if needed',
      ],
      icon: Icons.sync,
      color: AppColors.primary,
    ),
    PackingTechnique(
      name: 'Folding',
      emoji: '📄',
      description: 'Traditional method for business attire',
      benefits: [
        'Professional appearance',
        'Organized layers',
        'Easy to stack',
        'Best for dress shirts and pants',
      ],
      steps: [
        'Lay the item on a flat surface',
        'Fold vertically along natural creases',
        'Fold horizontally to desired size',
        'Stack neatly in compartment',
      ],
      icon: Icons.view_agenda,
      color: AppColors.secondary,
    ),
    PackingTechnique(
      name: 'Bundling',
      emoji: '🎁',
      description: 'Advanced technique for wrinkle-free packing',
      benefits: [
        'Maximum wrinkle prevention',
        'Space efficient',
        'Professional results',
        'Ideal for suits and dresses',
      ],
      steps: [
        'Place largest items flat as base',
        'Layer smaller items on top',
        'Wrap everything around a central core',
        'Secure the bundle gently',
      ],
      icon: Icons.inventory_2,
      color: AppColors.accent,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _techniques.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusXl)),
      ),
      child: Column(
        children: [
          // Handle
          Padding(
            padding: const EdgeInsets.only(top: AppConstants.spacingMd),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Packing Techniques', style: AppTextStyles.headlineMedium),
                      Text(
                        'Learn professional packing methods',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLg),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTextStyles.labelMedium,
              tabs: _techniques.map((tech) {
                return Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tech.emoji),
                      const SizedBox(width: 4),
                      Text(tech.name),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _techniques.map((tech) {
                return _buildTechniqueContent(tech);
              }).toList(),
            ),
          ),

          // Close Button
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLg),
            child: GradientButton(
              text: 'Got It!',
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechniqueContent(PackingTechnique technique) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon & Description
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: technique.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                ),
                child: Center(
                  child: Icon(
                    technique.icon,
                    color: technique.color,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(width: AppConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(technique.name, style: AppTextStyles.headlineSmall),
                    const SizedBox(height: 4),
                    Text(technique.description, style: AppTextStyles.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingXl),

          // Benefits
          Text('Benefits', style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppConstants.spacingMd),
          ...technique.benefits.map((benefit) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppConstants.spacingSm),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 7, right: 8),
                    decoration: BoxDecoration(
                      color: technique.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(benefit, style: AppTextStyles.bodyMedium),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: AppConstants.spacingXl),

          // Steps
          Text('How to ${technique.name}', style: AppTextStyles.headlineSmall),
          const SizedBox(height: AppConstants.spacingMd),
          ...technique.steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: AppConstants.spacingMd),
              padding: const EdgeInsets.all(AppConstants.spacingMd),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMd),
                  Expanded(
                    child: Text(step, style: AppTextStyles.bodyMedium),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// Model
class PackingTechnique {
  final String name;
  final String emoji;
  final String description;
  final List<String> benefits;
  final List<String> steps;
  final IconData icon;
  final Color color;

  PackingTechnique({
    required this.name,
    required this.emoji,
    required this.description,
    required this.benefits,
    required this.steps,
    required this.icon,
    required this.color,
  });
}
