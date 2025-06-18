import 'package:assesment/controllers/auth-controller.dart';
import 'package:assesment/views/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final isHidden = true.obs;

  @override
  Widget build(BuildContext context) {
    final auth = Get.put(AuthController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back 👋",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Login to your account",
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 30),

            // Email
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Password
            Obx(
              () => TextField(
                controller: passCtrl,
                obscureText: isHidden.value,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isHidden.value ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => isHidden.toggle(),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => auth.loginWithEmail(
                  emailCtrl.text.trim(),
                  passCtrl.text.trim(),
                ),
                child: Text("Login", style: TextStyle(fontSize: 16)),
              ),
            ),

            SizedBox(height: 12),

            Center(
              child: TextButton(
                onPressed: () => Get.to(() => SignUpPage()),
                child: Text("Don't have an account? Sign up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
