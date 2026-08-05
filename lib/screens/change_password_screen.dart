import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState
    extends State<ChangePasswordScreen> {

  final oldController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: const Color(0xff2856A6),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xffF5F7FB),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: oldController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Current Password",
              ),
            ),

            const SizedBox(height:20),

            TextField(
              controller: newController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "New Password",
              ),
            ),

            const SizedBox(height:20),

            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirm Password",
              ),
            ),

            const SizedBox(height:30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Password updated successfully"),
                    ),
                  );

                  Navigator.pop(context);
                },

                child: const Text("Update Password"),
              ),
            )

          ],
        ),
      ),
    );
  }
}