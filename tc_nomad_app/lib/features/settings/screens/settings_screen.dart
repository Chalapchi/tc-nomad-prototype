import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: AppConstants.spacingMd),

          // Profile Section
          _buildSection(
            'Profile',
            [
              _buildListTile(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.email_outlined,
                title: 'Email',
                subtitle: 'user@example.com',
                onTap: () {},
              ),
            ],
          ),

          // Preferences Section
          _buildSection(
            'Preferences',
            [
              _buildListTile(
                icon: Icons.thermostat_outlined,
                title: 'Temperature Unit',
                subtitle: 'Celsius',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.straighten_outlined,
                title: 'Measurement Unit',
                subtitle: 'Metric',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.dark_mode_outlined,
                title: 'Theme',
                subtitle: 'System',
                onTap: () {},
              ),
            ],
          ),

          // Subscription Section
          _buildSection(
            'Subscription',
            [
              _buildListTile(
                icon: Icons.diamond_outlined,
                title: 'Upgrade to Pro',
                subtitle: 'Unlock unlimited trips & AI generations',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'FREE',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),

          // Support Section
          _buildSection(
            'Support',
            [
              _buildListTile(
                icon: Icons.help_outline,
                title: 'Help Center',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.feedback_outlined,
                title: 'Send Feedback',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.bug_report_outlined,
                title: 'Report a Bug',
                onTap: () {},
              ),
            ],
          ),

          // Legal Section
          _buildSection(
            'Legal',
            [
              _buildListTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy Policy',
                onTap: () {},
              ),
              _buildListTile(
                icon: Icons.description_outlined,
                title: 'Terms of Service',
                onTap: () {},
              ),
            ],
          ),

          // Account Section
          _buildSection(
            'Account',
            [
              _buildListTile(
                icon: Icons.logout,
                title: 'Log Out',
                titleColor: AppColors.error,
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: AppConstants.spacingLg),

          // App Version
          Center(
            child: Text(
              'TC Nomad v${AppConstants.appVersion}',
              style: AppTextStyles.caption,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.spacingLg,
            AppConstants.spacingMd,
            AppConstants.spacingLg,
            AppConstants.spacingSm,
          ),
          child: Text(
            title.toUpperCase(),
            style: AppTextStyles.overline,
          ),
        ),
        Container(
          color: Colors.white,
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppColors.textPrimary),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(color: titleColor),
      ),
      subtitle: subtitle != null
          ? Text(subtitle, style: AppTextStyles.bodySmall)
          : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: onTap,
    );
  }
}
