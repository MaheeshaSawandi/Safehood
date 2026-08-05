import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: const Color(0xff2856A6),
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          notificationCard(
            Icons.warning_amber_rounded,
            Colors.red,
            "High Crime Alert",
            "High crime risk detected in Colombo 07. Stay alert.",
            "10 mins ago",
          ),

          notificationCard(
            Icons.local_police,
            Colors.blue,
            "Police Update",
            "Police patrols increased in your nearby area.",
            "1 hour ago",
          ),

          notificationCard(
            Icons.location_on,
            Colors.orange,
            "Travel Advisory",
            "Avoid Main Street after 9:00 PM due to recent incidents.",
            "3 hours ago",
          ),

          notificationCard(
            Icons.check_circle,
            Colors.green,
            "Area Safe",
            "No major incidents reported today in your selected area.",
            "Yesterday",
          ),

          notificationCard(
            Icons.feedback_outlined,
            Colors.purple,
            "Feedback Received",
            "Thank you for helping improve SafeHood.",
            "2 days ago",
          ),

        ],
      ),
    );
  }

  Widget notificationCard(
    IconData icon,
    Color color,
    String title,
    String message,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
          )
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}