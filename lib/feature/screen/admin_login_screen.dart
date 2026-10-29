import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mivo/core/app/app_colors.dart';
import 'package:mivo/core/custom_widgets/custom_button/custom_button.dart';
import 'package:mivo/core/custom_widgets/custom_text/custom_text.dart';
import 'package:mivo/core/custom_widgets/custom_text_field/custom_text_field.dart';
import 'package:mivo/feature/screen/mobile_screen.dart';
import 'package:mivo/feature/supabase_data/s_auth.dart';

/// Shown on mobile before the settings page. Only the admin account can pass.
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _hidePassword = true;
  String? _error;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final error = await SupabaseAuth.instance.signIn(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    if (error != null) {
      setState(() {
        _isLoading = false;
        _error = error;
      });
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const QrCreate()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 56,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: 16.h),
                const CustomText(
                  text: 'Admin Sign In',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 6.h),
                const CustomText(
                  text: 'Only the site owner can manage settings.',
                  fontSize: 14,
                  color: AppColors.lightTextSecondary,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 28.h),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: const Icon(Icons.email_outlined),
                  enabled: !_isLoading,
                ),
                SizedBox(height: 12.h),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _hidePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _signIn(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  enabled: !_isLoading,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hidePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _hidePassword = !_hidePassword),
                  ),
                ),
                if (_error != null) ...[
                  SizedBox(height: 12.h),
                  CustomText(
                    text: _error!,
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 13,
                    textAlign: TextAlign.center,
                  ),
                ],
                SizedBox(height: 24.h),
                CustomButton(
                  text: 'Sign In',
                  isLoading: _isLoading,
                  onTap: _signIn,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
