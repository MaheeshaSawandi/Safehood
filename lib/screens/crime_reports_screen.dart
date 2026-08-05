import 'package:flutter/material.dart';

class CrimeReportsScreen extends StatefulWidget {
  const CrimeReportsScreen({super.key});

  @override
  State<CrimeReportsScreen> createState() => _CrimeReportsScreenState();
}

class _CrimeReportsScreenState extends State<CrimeReportsScreen> {

  final List<Map<String, String>> reports = [

    {
      "crime": "Robbery",
      "location": "Colombo 07",
      "date": "02 Aug 2026",
      "status": "Pending",
    },

    {
      "crime": "Vehicle Theft",
      "location": "Kandy",
      "date": "01 Aug 2026",
      "status": "Investigating",
    },

    {
      "crime": "Assault",
      "location": "Galle",
      "date": "30 Jul 2026",
      "status": "Resolved",
    },

    {
      "crime": "Burglary",
      "location": "Jaffna",
      "date": "28 Jul 2026",
      "status": "Pending",
    },

  ];

  Color statusColor(String status) {

    switch (status) {

      case "Resolved":
        return Colors.green;

      case "Investigating":
        return Colors.orange;

      default:
        return Colors.red;

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
          "Crime Reports",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(

              decoration: InputDecoration(

                hintText: "Search reports...",

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

                itemCount: reports.length,

                itemBuilder: (context, index) {

                  final report = reports[index];

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

                                  Icons.report,

                                  color: Colors.red,

                                ),

                              ),

                              const SizedBox(width: 15),

                              Expanded(

                                child: Text(

                                  report["crime"]!,

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

                                  color: statusColor(
                                    report["status"]!,
                                  ).withValues(alpha: 0.15),

                                  borderRadius:
                                      BorderRadius.circular(20),

                                ),

                                child: Text(

                                  report["status"]!,

                                  style: TextStyle(

                                    color: statusColor(
                                      report["status"]!,
                                    ),

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
                                color: Colors.blue,
                                size: 18,
                              ),

                              const SizedBox(width: 5),

                              Text(report["location"]!),

                            ],

                          ),

                          const SizedBox(height: 8),

                          Row(

                            children: [

                              const Icon(
                                Icons.calendar_today,
                                color: Colors.blue,
                                size: 18,
                              ),

                              const SizedBox(width: 5),

                              Text(report["date"]!),

                            ],

                          ),

                          const Divider(height: 25),

                          Row(

                            mainAxisAlignment:
                                MainAxisAlignment.end,

                            children: [

                              ElevatedButton.icon(

                                style: ElevatedButton.styleFrom(

                                  backgroundColor: Colors.blue,

                                ),

                                onPressed: () {

                                  showDialog(

                                    context: context,

                                    builder: (_) => AlertDialog(

                                      title: const Text(
                                        "Crime Report",
                                      ),

                                      content: Text(

                                        "Crime : ${report["crime"]}\n\n"

                                        "Location : ${report["location"]}\n\n"

                                        "Date : ${report["date"]}\n\n"

                                        "Status : ${report["status"]}",

                                      ),

                                      actions: [

                                        TextButton(

                                          onPressed: () {

                                            Navigator.pop(context);

                                          },

                                          child: const Text("Close"),

                                        )

                                      ],

                                    ),

                                  );

                                },

                                icon: const Icon(

                                  Icons.visibility,

                                  color: Colors.white,

                                ),

                                label: const Text(

                                  "View",

                                  style: TextStyle(
                                    color: Colors.white,
                                  ),

                                ),

                              ),

                              const SizedBox(width: 10),

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
                                          "Delete Report",
                                        ),

                                        content: Text(

                                          "Delete ${report["crime"]} report?",

                                        ),

                                        actions: [

                                          TextButton(

                                            onPressed: () {

                                              Navigator.pop(context);

                                            },

                                            child: const Text(
                                              "Cancel",
                                            ),

                                          ),

                                          ElevatedButton(

                                            style:
                                                ElevatedButton.styleFrom(

                                              backgroundColor: Colors.red,

                                            ),

                                            onPressed: () {

                                              setState(() {

                                                reports.removeAt(index);

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