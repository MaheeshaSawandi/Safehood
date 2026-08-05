import 'package:flutter/material.dart';

class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Crime Alerts",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          alertCard(
            "High Risk",
            "Colombo 07",
            "Several theft incidents reported during the last 24 hours.",
            "10 mins ago",
            Colors.red,
          ),

          alertCard(
            "Moderate Risk",
            "Kandy",
            "Increase in vehicle thefts reported this week.",
            "35 mins ago",
            Colors.orange,
          ),

          alertCard(
            "Low Risk",
            "Galle",
            "Area remains generally safe with very few reported incidents.",
            "1 hour ago",
            Colors.green,
          ),

          alertCard(
            "High Risk",
            "Negombo",
            "Night-time robberies have increased around the town centre.",
            "2 hours ago",
            Colors.red,
          ),

          alertCard(
            "Moderate Risk",
            "Kurunegala",
            "Several public complaints received regarding suspicious activities.",
            "Yesterday",
            Colors.orange,
          ),

          alertCard(
            "Low Risk",
            "Anuradhapura",
            "No major crime incidents recorded recently.",
            "Yesterday",
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget alertCard(
    String risk,
    String location,
    String description,
    String time,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(
                Icons.warning_amber_rounded,
                color: color,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    risk,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    location,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        time,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}