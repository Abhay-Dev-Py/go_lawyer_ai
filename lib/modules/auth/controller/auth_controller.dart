import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_lawyer_ai/routes/app_routes.dart';
import 'package:go_lawyer_ai/services/firebase_service.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService = Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Listen to auth state changes
    ever(currentUser, handleAuthChanged);
    currentUser.bindStream(_firebaseService.authStateChanges);
  }

  void handleAuthChanged(User? user) {
    if (user != null) {
      Get.offAllNamed(AppRoutes.conversations);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> signIn() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _firebaseService.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _firebaseService.createUserWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  bool _validateInputs() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || !GetUtils.isEmail(email)) {
      errorMessage.value = 'Please enter a valid email address';
      return false;
    }

    if (password.isEmpty || password.length < 6) {
      errorMessage.value = 'Password must be at least 6 characters long';
      return false;
    }

    return true;
  }
}
