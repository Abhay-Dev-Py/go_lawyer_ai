import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_lawyer_ai/services/api_service.dart';
import 'package:go_lawyer_ai/services/firebase_service.dart';

class ChatController extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  final ApiService _apiService = Get.find();

  final messageController = TextEditingController();
  final scrollController = ScrollController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final messages = <QueryDocumentSnapshot>[].obs;

  late final String conversationId;
  final title = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get conversation ID from route parameters
    conversationId = Get.parameters['id'] ?? '';
    // Get title from arguments
    title.value = Get.arguments?['title'] ?? 'Chat';

    if (conversationId.isEmpty) {
      errorMessage.value = 'Invalid conversation ID';
      return;
    }

    _listenToMessages();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  void _listenToMessages() {
    try {
      _firebaseService.getMessages(conversationId).listen(
        (QuerySnapshot snapshot) {
          messages.value = snapshot.docs;
          // Scroll to bottom after messages update
          Future.delayed(
            const Duration(milliseconds: 100),
            () => _scrollToBottom(),
          );
        },
        onError: (error) {
          errorMessage.value = 'Failed to load messages: $error';
        },
      );
    } catch (e) {
      errorMessage.value = 'Failed to initialize message listener: $e';
    }
  }

  Future<void> sendMessage() async {
    final message = messageController.text.trim();
    if (message.isEmpty) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Save user message
      await _firebaseService.sendMessage(
        conversationId: conversationId,
        message: message,
        sender: 'user',
      );

      // Clear input field
      messageController.clear();

      // Get AI response
      final response = await _apiService.askLegalQuestion(message);

      // Save AI response
      await _firebaseService.sendMessage(
        conversationId: conversationId,
        message: response['legal_advice'] as String,
        sender: 'bot',
      );
    } catch (e) {
      errorMessage.value = 'Failed to send message: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';

    final date = timestamp.toDate();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(date.year, date.month, date.day);

    if (messageDate == today) {
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }

    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
