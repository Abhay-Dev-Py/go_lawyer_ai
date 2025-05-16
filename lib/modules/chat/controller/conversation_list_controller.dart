import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:go_lawyer_ai/models/conversation.dart';
import 'package:go_lawyer_ai/routes/app_routes.dart';
import 'package:go_lawyer_ai/services/firebase_service.dart';

class ConversationListController extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  final conversations = <Conversation>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  StreamSubscription<QuerySnapshot>? _conversationsSubscription;

  @override
  void onInit() {
    super.onInit();
    _listenToConversations();
  }

  @override
  void onClose() {
    _conversationsSubscription?.cancel();
    super.onClose();
  }

  void _listenToConversations() {
    try {
      final userId = _firebaseService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not authenticated';
        return;
      }

      print('Current User ID: $userId'); // Debug print

      _conversationsSubscription = FirebaseFirestore.instance
          .collection('conversations')
          .where('userId', isEqualTo: userId)
          .orderBy('lastMessageTimestamp', descending: true)
          .snapshots()
          .listen(
        (snapshot) {
          print('Snapshot docs length: ${snapshot.docs.length}'); // Debug print
          conversations.value = snapshot.docs.map((doc) {
            final data = doc.data();
            print('Conversation data: $data'); // Debug print
            return Conversation(
              id: doc.id,
              title: data['title'] ?? 'Untitled',
              lastMessage: data['lastMessage'] ?? '',
              lastMessageTimestamp: data['lastMessageTimestamp'] != null
                  ? (data['lastMessageTimestamp'] as Timestamp).toDate()
                  : DateTime.now(),
              userId: data['userId'],
            );
          }).toList();
        },
        onError: (error) {
          print('Firestore error: $error'); // Debug print
          errorMessage.value = 'Failed to load conversations: $error';
        },
      );
    } catch (e) {
      print('Exception: $e'); // Debug print
      errorMessage.value = 'Failed to initialize conversation listener: $e';
    }
  }

  Future<void> createNewConversation(String title) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final userId = _firebaseService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not authenticated';
        return;
      }

      final docRef =
          await FirebaseFirestore.instance.collection('conversations').add({
        'title': title,
        'userId': userId,
        'lastMessage': '',
        'lastMessageTimestamp': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Create messages subcollection
      await docRef.collection('messages').add({
        'message': 'Conversation started',
        'sender': 'system',
        'timestamp': FieldValue.serverTimestamp(),
      });

      Get.toNamed(AppRoutes.chat.replaceAll(':id', docRef.id));
    } catch (e) {
      errorMessage.value = 'Failed to create conversation: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteConversation(String conversationId) async {
    try {
      final userId = _firebaseService.currentUser?.uid;
      if (userId == null) {
        errorMessage.value = 'User not authenticated';
        return false;
      }

      // First verify that this conversation belongs to the current user
      final conversationDoc = await FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .get();

      if (!conversationDoc.exists) {
        errorMessage.value = 'Conversation not found';
        return false;
      }

      final data = conversationDoc.data();
      if (data?['userId'] != userId) {
        errorMessage.value =
            'You do not have permission to delete this conversation';
        return false;
      }

      // Delete all messages in the conversation
      final messagesSnapshot = await FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .get();

      final batch = FirebaseFirestore.instance.batch();
      for (var doc in messagesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Delete the conversation document
      batch.delete(conversationDoc.reference);

      await batch.commit();
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to delete conversation: ${e.toString()}';
      return false;
    }
  }

  void navigateToChat(String conversationId) {
    Get.toNamed(AppRoutes.chat.replaceAll(':id', conversationId));
  }

  String formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate =
        DateTime(timestamp.year, timestamp.month, timestamp.day);

    if (messageDate == today) {
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    }

    return '${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
