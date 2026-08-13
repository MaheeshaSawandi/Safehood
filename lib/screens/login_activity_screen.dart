import 'package:flutter/material.dart';

class LoginActivityScreen extends StatelessWidget {
  const LoginActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Login Activity"),
        backgroundColor: const Color(0xff2856A6),
        foregroundColor: Colors.white,
      ),

      body: ListView(

        children: const [

          ListTile(
            leading: Icon(Icons.phone_android),
            title: Text("Samsung Galaxy A54"),
            subtitle: Text("Today • 10:45 AM"),
          ),

          Divider(),

          ListTile(
            leading: Icon(Icons.laptop),
            title: Text("Windows PC"),
            subtitle: Text("Yesterday • 8:15 PM"),
          ),

          Divider(),

          ListTile(
            leading: Icon(Icons.phone_android),
            title: Text("Redmi Note 13"),
            subtitle: Text("2 days ago"),
          ),

        ],
      ),
    );
  }
}