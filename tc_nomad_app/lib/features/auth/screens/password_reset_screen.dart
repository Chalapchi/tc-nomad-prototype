import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: _emailSent ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: AppConstants.spacingXl),

          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_reset,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingLg),

          // Title
          Text(
            'Reset Password',
            style: AppTextStyles.displayMedium,
          ),
          const SizedBox(height: AppConstants.spacingSm),
          Text(
            'Enter your email and we\'ll send you instructions to reset your password',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXl),

          // Email Field
          CustomTextField(
            label: 'Email',
            hint: 'Enter your email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: Validators.email,
          ),
          const SizedBox(height: AppConstants.spacingXl),

          // Send Button
          GradientButton(
            text: 'Send Reset Link',
            onPressed: _handleResetPassword,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppConstants.spacing2xl),

        // Success Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline,
            size: 60,
            color: AppColors.success,
          ),
        ),
        const SizedBox(height: AppConstants.spacingLg),

        // Success Message
        Text(
          'Check Your Email',
          style: AppTextStyles.displayMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.spacingSm),
        Text(
          'We\'ve sent password reset instructions to ${_emailController.text}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppConstants.spacingXl),

        // Back to Login
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Back to Login'),
        ),
      ],
    );
  }
}
