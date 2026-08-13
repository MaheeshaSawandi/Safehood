import 'package:flutter/material.dart';

class ManageAlertsScreen extends StatefulWidget {
  const ManageAlertsScreen({super.key});

  @override
  State<ManageAlertsScreen> createState() => _ManageAlertsScreenState();
}

class _ManageAlertsScreenState extends State<ManageAlertsScreen> {

  final List<Map<String, String>> alerts = [

    {
      "title": "Robbery Alert",
      "location": "Colombo 07",
      "date": "02 Aug 2026",
      "severity": "High",
    },

    {
      "title": "Road Accident",
      "location": "Kandy",
      "date": "01 Aug 2026",
      "severity": "Medium",
    },

    {
      "title": "Flood Warning",
      "location": "Galle",
      "date": "31 Jul 2026",
      "severity": "High",
    },

    {
      "title": "Fire Incident",
      "location": "Kurunegala",
      "date": "30 Jul 2026",
      "severity": "Low",
    },

  ];

  Color getSeverityColor(String severity) {
    switch (severity) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(

        backgroundColor: const Color(0xff2856A6),

        foregroundColor: Colors.white,

        title: const Text(
          "Manage Alerts",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

      ),

      floatingActionButton: FloatingActionButton(

        backgroundColor: Colors.blue,

        child: const Icon(
          Icons.add_alert,
          color: Colors.white,
        ),

        onPressed: () {

          ScaffoldMessenger.of(context).showSnackBar(

            const SnackBar(
              content: Text("Add Alert Clicked"),
            ),

          );

        },

      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(

              decoration: InputDecoration(

                hintText: "Search alerts...",

                prefixIcon: const Icon(Icons.search),

                filled: true,

                fillColor: Colors.white,

                border: OutlineInputBorder(

                  borderRadius: BorderRadius.circular(15),

                  borderSide: BorderSide.none,

                ),

              ),

            ),

            const SizedBox(height: 20),

            Expanded(

              child: ListView.builder(

                itemCount: alerts.length,

                itemBuilder: (context, index) {

                  final alert = alerts[index];

                  return Card(

                    elevation: 3,

                    margin: const EdgeInsets.only(bottom: 15),

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(15),

                    ),

                    child: Padding(

                      padding: const EdgeInsets.all(15),

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Row(

                            children: [

                              CircleAvatar(

                                radius: 25,

                                backgroundColor: Colors.red.shade100,

                                child: const Icon(

                                  Icons.warning,

                                  color: Colors.red,

                                ),

                              ),

                              const SizedBox(width: 15),

                              Expanded(

                                child: Text(

                                  alert["title"]!,

                                  style: const TextStyle(

                                    fontSize: 17,

                                    fontWeight: FontWeight.bold,

                                  ),

                                ),

                              ),

                              Container(

                                padding: const EdgeInsets.symmetric(

                                  horizontal: 10,

                                  vertical: 5,

                                ),

                                decoration: BoxDecoration(

                                  color: getSeverityColor(
                                      alert["severity"]!).withValues(alpha: 0.15),

                                  borderRadius:
                                      BorderRadius.circular(20),

                                ),

                                child: Text(

                                  alert["severity"]!,

                                  style: TextStyle(

                                    color: getSeverityColor(
                                        alert["severity"]!),

                                    fontWeight: FontWeight.bold,

                                  ),

                                ),

                              ),

                            ],

                          ),

                          const SizedBox(height: 15),

                          Row(

                            children: [

                              const Icon(
                                Icons.location_on,
                                size: 18,
                                color: Colors.blue,
                              ),

                              const SizedBox(width: 5),

                              Text(alert["location"]!),

                            ],

                          ),

                          const SizedBox(height: 8),

                          Row(

                            children: [

                              const Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: Colors.blue,
                              ),

                              const SizedBox(width: 5),

                              Text(alert["date"]!),

                            ],

                          ),

                          const Divider(height: 25),

                          Row(

                            mainAxisAlignment:
                                MainAxisAlignment.end,

                            children: [

                              IconButton(

                                icon: const Icon(

                                  Icons.edit,

                                  color: Colors.orange,

                                ),

                                onPressed: () {

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(

                                    SnackBar(

                                      content: Text(
                                          "Edit ${alert["title"]}"),

                                    ),

                                  );

                                },

                              ),

                              IconButton(

                                icon: const Icon(

                                  Icons.delete,

                                  color: Colors.red,

                                ),

                                onPressed: () {

                                  showDialog(

                                    context: context,

                                    builder: (_) {

                                      return AlertDialog(

                                        title: const Text(
                                            "Delete Alert"),

                                        content: Text(
                                            "Delete ${alert["title"]}?"),

                                        actions: [

                                          TextButton(

                                            onPressed: () {

                                              Navigator.pop(context);

                                            },

                                            child:
                                                const Text("Cancel"),

                                          ),

                                          ElevatedButton(

                                            style:
                                                ElevatedButton.styleFrom(

                                              backgroundColor:
                                                  Colors.red,

                                            ),

                                            onPressed: () {

                                              setState(() {

                                                alerts.removeAt(index);

                                              });

                                              Navigator.pop(context);

                                            },

                                            child: const Text(

                                              "Delete",

                                              style: TextStyle(
                                                color: Colors.white,
                                              ),

                                            ),

                                          ),

                                        ],

                                      );

                                    },

                                  );

                                },

                              ),

                            ],

                          ),

                        ],

                      ),

                    ),

                  );

                },

              ),

            ),

          ],

        ),

      ),

    );

  }

}