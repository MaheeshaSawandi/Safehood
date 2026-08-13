import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'admin_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() =>
      _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {

  final TextEditingController _passwordController =
      TextEditingController();

  // ============================================
  // HARD-CODED ADMIN PASSWORD
  // ============================================

  final String _adminPassword =
      "we5bloom*21/22";


  // ============================================
  // SAVE LOGIN TO SUPABASE
  // ============================================

  Future<void> _saveAdminLogin() async {

    try {

      final supabase =
          Supabase.instance.client;

      await supabase
          .from('admin_login')
          .insert({
        'username': 'admin',
        'login_status': 'success',
        'login_time':
            DateTime.now()
                .toUtc()
                .toIso8601String(),
      });

      debugPrint(
        "Admin login saved to Supabase successfully.",
      );

    } catch (e) {

      debugPrint(
        "Supabase admin login error: $e",
      );

    }
  }


  // ============================================
  // ADMIN LOGIN
  // ============================================

  Future<void> _loginAdmin() async {

    if (_passwordController.text ==
        _adminPassword) {

      // Save successful login to Supabase
      await _saveAdminLogin();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const AdminScreen(),
        ),
      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
              Text("Incorrect Password"),

          backgroundColor:
              Colors.red,

        ),

      );
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xffF5F7FB),

      appBar: AppBar(

        title: const Text(
          "Admin Login",
        ),

        backgroundColor:
            const Color(0xff2856A6),

        foregroundColor:
            Colors.white,

      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            const SizedBox(height: 40),

            Container(

              height: 90,

              width: 90,

              decoration:
                  BoxDecoration(

                color:
                    Colors.blue.shade50,

                shape:
                    BoxShape.circle,

              ),

              child: const Icon(

                Icons.admin_panel_settings,

                size: 55,

                color: Colors.blue,

              ),

            ),

            const SizedBox(height: 25),

            const Text(

              "Administrator Access",

              style: TextStyle(

                fontSize: 22,

                fontWeight:
                    FontWeight.bold,

              ),

            ),

            const SizedBox(height: 30),

            TextField(

              controller:
                  _passwordController,

              obscureText: true,

              decoration:
                  InputDecoration(

                labelText:
                    "Password",

                prefixIcon:
                    const Icon(
                  Icons.lock,
                ),

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                ),

              ),

            ),

            const SizedBox(height: 25),

            SizedBox(

              width: double.infinity,

              height: 50,

              child: ElevatedButton(

                style:
                    ElevatedButton.styleFrom(

                  backgroundColor:
                      const Color(
                    0xff2856A6,
                  ),

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),

                  ),

                ),

                onPressed:
                    _loginAdmin,

                child:
                    const Text(

                  "LOGIN",

                  style: TextStyle(

                    color: Colors.white,

                    fontSize: 16,

                    fontWeight:
                        FontWeight.bold,

                  ),

                ),

              ),

            ),

          ],

        ),

      ),

    );
  }


  @override
  void dispose() {

    _passwordController.dispose();

    super.dispose();
  }
}