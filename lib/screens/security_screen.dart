import 'package:flutter/material.dart';

import 'change_password_screen.dart';
import 'login_activity_screen.dart';
import 'privacy_policy_screen.dart';
import 'security_tips_screen.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool biometric = false;
  bool locationSharing = true;
  bool twoFactor = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        title: const Text("Security & Privacy"),
        backgroundColor: const Color(0xff2856A6),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _switchTile(
              Icons.fingerprint,
              "Biometric Authentication",
              biometric,
              (value) {
                setState(() {
                  biometric = value;
                });
              },
            ),

            const SizedBox(height: 15),

            _switchTile(
              Icons.location_on_outlined,
              "Location Sharing",
              locationSharing,
              (value) {
                setState(() {
                  locationSharing = value;
                });
              },
            ),

            const SizedBox(height: 15),

            _switchTile(
              Icons.verified_user_outlined,
              "Two-Factor Authentication",
              twoFactor,
              (value) {
                setState(() {
                  twoFactor = value;
                });
              },
            ),

            const SizedBox(height: 20),

            _menuTile(
              Icons.lock_outline,
              "Change Password",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChangePasswordScreen(),
                  ),
                );
              },
            ),

            _menuTile(
              Icons.history,
              "Login Activity",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginActivityScreen(),
                  ),
                );
              },
            ),

            _menuTile(
              Icons.privacy_tip_outlined,
              "Privacy Policy",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PrivacyPolicyScreen(),
                  ),
                );
              },
            ),

            _menuTile(
              Icons.security,
              "Security Tips",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SecurityTipsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Security settings saved.",
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2856A6),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(
    IconData icon,
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: Colors.blue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _menuTile(
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}