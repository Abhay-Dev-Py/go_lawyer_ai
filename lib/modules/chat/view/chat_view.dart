import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_lawyer_ai/constants/app_colors.dart';
import 'package:go_lawyer_ai/modules/auth/controller/auth_controller.dart';
import 'package:go_lawyer_ai/modules/chat/controller/chat_controller.dart';
import 'package:go_lawyer_ai/modules/chat/widgets/chat_bubble.dart';
import 'package:go_lawyer_ai/utils/responsive_widget.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    Get.put(ChatController());
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GoLawyer AI'),
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
    return Column(
      children: [
        Expanded(
          child: _buildChatList(),
        ),
        _buildInputArea(),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 80.w(context),
        child: _buildMobileLayout(context),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 60.w(context),
        child: _buildMobileLayout(context),
      ),
    );
  }

  Widget _buildChatList() {
    return Obx(() {
      if (controller.messages.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 64,
                color: AppColors.primary.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Start a conversation',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.all(16),
        reverse: true,
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          final message = controller.messages[index];
          final data = message.data() as Map<String, dynamic>;
          final isUser = data['sender'] == 'user';
          final timestamp = data['timestamp'] as Timestamp?;

          return ChatBubble(
            message: data['message'] as String,
            isUser: isUser,
            time: controller.formatTimestamp(timestamp),
          );
        },
      );
    });
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller.messageController,
                decoration: InputDecoration(
                  hintText: 'Ask your legal question...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => controller.sendMessage(),
              ),
            ),
            const SizedBox(width: 8),
            Obx(() => IconButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.sendMessage,
                  icon: controller.isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.send),
                  color: AppColors.primary,
                )),
          ],
        ),
      ),
    );
  }
}
