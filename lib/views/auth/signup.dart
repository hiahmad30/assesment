import 'package:assesment/controllers/auth-controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
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
              "Join Us ✨",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Create your account",
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 30),

            // Email
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
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
                  prefixIcon: Icon(Icons.lock),
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
            SizedBox(height: 20),

            // Confirm Password
            TextField(
              controller: confirmCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 30),

            // Signup Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (passCtrl.text.trim() == confirmCtrl.text.trim()) {
                    auth.registerWithEmail(
                      emailCtrl.text.trim(),
                      passCtrl.text.trim(),
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      'Passwords do not match',
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: Text("Sign Up", style: TextStyle(fontSize: 16)),
              ),
            ),

            SizedBox(height: 12),

            Center(
              child: TextButton(
                onPressed: () => Get.back(),
                child: Text("Already have an account? Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
