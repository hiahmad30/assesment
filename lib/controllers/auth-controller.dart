import 'package:assesment/views/home/home-page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Reactive User object
  Rxn<User> firebaseUser = Rxn<User>();

  // Lifecycle method
  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  /// SIGN UP with email and password
  Future<void> registerWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.snackbar(
        'Success',
        'Account created successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.off(() => HomePage());
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Sign Up Failed',
        e.message ?? 'Unknown error',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// SIGN IN with email and password
  Future<void> loginWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar(
        'Success',
        'Logged in successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.off(() => HomePage());
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Login Failed',
        e.message ?? 'Unknown error',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// SIGN OUT
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Check if user is logged in
  bool get isLoggedIn => firebaseUser.value != null;
}
