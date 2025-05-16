import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_lawyer_ai/constants/app_colors.dart';
import 'package:go_lawyer_ai/modules/auth/controller/auth_controller.dart';
import 'package:go_lawyer_ai/routes/app_routes.dart';
import 'package:go_lawyer_ai/utils/responsive_widget.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller if not already initialized
    Get.put(AuthController());

    return Scaffold(
      body: ResponsiveWidget(
        mobile: _buildMobileLayout(context),
        tablet: _buildTabletLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: 20.horizontal + 40.vertical,
        child: _buildRegisterForm(context),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 60.w(context),
        child: _buildMobileLayout(context),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            color: AppColors.primary,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'GoLawyer AI',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32.sp(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your AI Legal Assistant',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16.sp(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: SizedBox(
              width: 60.w(context) / 2,
              child: _buildMobileLayout(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (ResponsiveWidget.isMobile(context)) ...[
          Text(
            'GoLawyer AI',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 32.sp(context),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
        ],
        Text(
          'Create Account',
          style: TextStyle(
            fontSize: 24.sp(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Sign up to get started',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.sp(context),
          ),
        ),
        const SizedBox(height: 32),
        TextField(
          controller: controller.emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: const Icon(Icons.email_outlined),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller.passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Create a password',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: const Icon(Icons.lock_outline),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        Obx(() => controller.errorMessage.isNotEmpty
            ? Padding(
                padding: 8.bottom,
                child: Text(
                  controller.errorMessage.value,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              )
            : const SizedBox.shrink()),
        Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: 16.vertical,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Sign Up'),
            )),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Already have an account?'),
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.login),
              child: const Text('Sign In'),
            ),
          ],
        ),
      ],
    );
  }
}
