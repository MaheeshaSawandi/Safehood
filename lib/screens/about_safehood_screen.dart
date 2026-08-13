import 'package:flutter/material.dart';

class AboutSafeHoodScreen extends StatelessWidget {
  const AboutSafeHoodScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(

        title: const Text("About SafeHood"),

        backgroundColor: const Color(0xff2856A6),

        foregroundColor: Colors.white,

      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Center(

              child: Icon(

                Icons.shield,

                size:80,

                color: Colors.blue,

              ),

            ),

            const SizedBox(height:20),

            const Center(

              child: Text(

                "SafeHood",

                style: TextStyle(

                  fontSize:26,

                  fontWeight: FontWeight.bold,

                ),

              ),

            ),

            const SizedBox(height:8),

            const Center(

              child: Text(

                "Version 1.0.0",

                style: TextStyle(

                  color: Colors.grey,

                ),

              ),

            ),

            const SizedBox(height:30),

            const Text(

              "SafeHood is a community safety application developed to help users identify safer areas, locate nearby emergency services, receive alerts, and report incidents. The application aims to improve public safety by providing real-time information and emergency assistance.",

              style: TextStyle(fontSize:16),

            ),

            const SizedBox(height:30),

            const Divider(),

            const Text(

              "Developed By",

              style: TextStyle(

                fontWeight: FontWeight.bold,

                fontSize:18,

              ),

            ),

            const SizedBox(height:10),

            const Text("SafeHood Development Team"),

          ],

        ),

      ),

    );

  }
}