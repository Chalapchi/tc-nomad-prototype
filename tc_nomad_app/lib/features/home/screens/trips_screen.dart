import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../services/subscription_service.dart';
import '../../trip/screens/trip_creation_wizard_screen.dart';
import '../../subscription/screens/paywall_screen.dart';

class TripsScreen extends StatelessWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Trips'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flight_outlined,
              size: 100,
              color: AppColors.textTertiary.withOpacity(0.5),
            ),
            const SizedBox(height: AppConstants.spacingLg),
            Text(
              'No trips yet',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: AppConstants.spacingSm),
            Text(
              'Start planning your next adventure',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (!SubscriptionService.canCreateTrip()) {
            // Show paywall when trip limit is reached
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PaywallScreen(canDismiss: true),
              ),
            );
            return;
          }

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const TripCreationWizardScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('New Trip'),
      ),
    );
  }
}
