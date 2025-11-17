import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';

class LuggageScreen extends StatelessWidget {
  const LuggageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Luggage Library'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.luggage_outlined,
              size: 100,
              color: AppColors.textTertiary.withOpacity(0.5),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Text(
              'No luggage profiles',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Add your luggage to get started',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Add Luggage'),
      ),
    );
  }
}
