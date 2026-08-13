import 'package:flutter/material.dart';

class SecurityTipsScreen extends StatelessWidget {
  const SecurityTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Security Tips"),
        backgroundColor: const Color(0xff2856A6),
        foregroundColor: Colors.white,
      ),

      body: ListView(

        padding: const EdgeInsets.all(20),

        children: const [

          ListTile(
            leading: Icon(Icons.security,color: Colors.green),
            title: Text("Enable Biometric Authentication"),
          ),

          ListTile(
            leading: Icon(Icons.lock,color: Colors.blue),
            title: Text("Use a strong password"),
          ),

          ListTile(
            leading: Icon(Icons.verified_user,color: Colors.orange),
            title: Text("Enable Two-Factor Authentication"),
          ),

          ListTile(
            leading: Icon(Icons.location_on,color: Colors.red),
            title: Text("Share your location only when necessary"),
          ),

          ListTile(
            leading: Icon(Icons.warning,color: Colors.deepOrange),
            title: Text("Avoid unknown Wi-Fi networks"),
          ),

          ListTile(
            leading: Icon(Icons.update,color: Colors.purple),
            title: Text("Keep SafeHood updated"),
          ),

        ],
      ),
    );
  }
}