import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Privacy Policy"),
        backgroundColor: const Color(0xff2856A6),
        foregroundColor: Colors.white,
      ),

      body: const Padding(

        padding: EdgeInsets.all(20),

        child: SingleChildScrollView(

          child: Text(

'''
SafeHood respects your privacy.

• Your location is used only to provide nearby safety information.

• Favourite locations are stored securely on your device.

• Personal information is never shared without your permission.

• Emergency contacts are only used during emergency features.

• You may disable location sharing anytime in Security Settings.

Thank you for using SafeHood.
''',

            style: TextStyle(
              fontSize: 16,
              height: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}