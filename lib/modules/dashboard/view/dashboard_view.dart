import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_lawyer_ai/constants/app_colors.dart';
import 'package:go_lawyer_ai/modules/auth/controller/auth_controller.dart';
import 'package:go_lawyer_ai/utils/responsive_widget.dart';

class DashboardView extends GetView<AuthController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: authController.signOut,
          ),
        ],
      ),
      body: ResponsiveWidget(
        mobile: _buildMobileLayout(context),
        tablet: _buildTabletLayout(context),
        desktop: _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Center(
      child: Text(
        'Dashboard Coming Soon',
        style: TextStyle(
          fontSize: 20.sp(context),
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return _buildMobileLayout(context);
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return _buildMobileLayout(context);
  }
}
