import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(

        title: const Text("Help & Support"),

        backgroundColor: const Color(0xff2856A6),

        foregroundColor: Colors.white,

      ),

      body: ListView(

        padding: const EdgeInsets.all(18),

        children: [

          Card(

            child: ListTile(

              leading: const Icon(Icons.email,color: Colors.blue),

              title: const Text("Email Support"),

              subtitle: const Text("support@safehood.com"),

            ),

          ),

          Card(

            child: ListTile(

              leading: const Icon(Icons.phone,color: Colors.green),

              title: const Text("Support Hotline"),

              subtitle: const Text("+94 11 2345678"),

            ),

          ),

          Card(

            child: ListTile(

              leading: const Icon(Icons.question_answer,color: Colors.orange),

              title: const Text("Frequently Asked Questions"),

              subtitle: const Text(
                "Find answers to common questions.",
              ),

            ),

          ),

          const SizedBox(height:20),

          const Text(

            "Need more help?",

            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),

          ),

          const SizedBox(height:10),

          const Text(

            "If you encounter any issues while using SafeHood, contact our support team via email or phone. We are available 24/7.",

          ),

        ],

      ),

    );

  }
}