import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/gradient_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/utils/validators.dart';
import '../../home/screens/home_screen.dart';
import 'sign_up_screen.dart';
import 'password_reset_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    // Implement Google Sign-In
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  Future<void> _handleAppleSignIn() async {
    // Implement Apple Sign-In
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppConstants.spacing2xl),

                // Logo
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: Center(
                      child: Text(
                        'TC',
                        style: AppTextStyles.displayLarge.copyWith(
                          fontSize: 36,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Welcome Text
                Text(
                  'Welcome Back',
                  style: AppTextStyles.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacingSm),
                Text(
                  'Sign in to continue your packing journey',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
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
                const SizedBox(height: AppConstants.spacingMd),

                // Password Field
                CustomTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.textTertiary,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  validator: (value) => Validators.required(value, fieldName: 'Password'),
                ),
                const SizedBox(height: AppConstants.spacingSm),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PasswordResetScreen()),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Login Button
                GradientButton(
                  text: 'Sign In',
                  onPressed: _handleLogin,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMd),
                      child: Text(
                        'OR',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingLg),

                // Social Sign-In Buttons
                OutlineButton(
                  text: 'Continue with Google',
                  onPressed: _handleGoogleSignIn,
                  icon: Icons.g_mobiledata,
                ),
                const SizedBox(height: AppConstants.spacingMd),
                OutlineButton(
                  text: 'Continue with Apple',
                  onPressed: _handleAppleSignIn,
                  icon: Icons.apple,
                ),
                const SizedBox(height: AppConstants.spacingXl),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyles.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SignUpScreen()),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
