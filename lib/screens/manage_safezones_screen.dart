import 'package:flutter/material.dart';

class ManageSafeZonesScreen extends StatefulWidget {
  const ManageSafeZonesScreen({super.key});

  @override
  State<ManageSafeZonesScreen> createState() =>
      _ManageSafeZonesScreenState();
}

class _ManageSafeZonesScreenState extends State<ManageSafeZonesScreen> {

  final List<Map<String, String>> safeZones = [

    {
      "name": "Colombo Police Station",
      "location": "Colombo 01",
      "risk": "Very Safe",
      "status": "Active",
    },

    {
      "name": "Kandy City Center",
      "location": "Kandy",
      "risk": "Safe",
      "status": "Active",
    },

    {
      "name": "Galle Bus Station",
      "location": "Galle",
      "risk": "Moderate",
      "status": "Monitoring",
    },

    {
      "name": "Negombo Beach",
      "location": "Negombo",
      "risk": "Safe",
      "status": "Active",
    },

  ];

  Color riskColor(String risk) {
    switch (risk) {
      case "Very Safe":
        return Colors.green;
      case "Safe":
        return Colors.blue;
      default:
        return Colors.orange;
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
          "Manage Safe Zones",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

      ),

      floatingActionButton: FloatingActionButton(

        backgroundColor: Colors.blue,

        child: const Icon(
          Icons.add_location_alt,
          color: Colors.white,
        ),

        onPressed: () {

          ScaffoldMessenger.of(context).showSnackBar(

            const SnackBar(
              content: Text("Add Safe Zone Clicked"),
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

                hintText: "Search Safe Zones...",

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

                itemCount: safeZones.length,

                itemBuilder: (context, index) {

                  final zone = safeZones[index];

                  return Card(

                    elevation: 3,

                    margin: const EdgeInsets.only(bottom: 15),

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(15),

                    ),

                    child: Padding(

                      padding: const EdgeInsets.all(15),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Row(

                            children: [

                              CircleAvatar(

                                radius: 25,

                                backgroundColor:
                                    Colors.green.shade100,

                                child: const Icon(

                                  Icons.location_on,

                                  color: Colors.green,

                                ),

                              ),

                              const SizedBox(width: 15),

                              Expanded(

                                child: Text(

                                  zone["name"]!,

                                  style: const TextStyle(

                                    fontSize: 17,

                                    fontWeight: FontWeight.bold,

                                  ),

                                ),

                              ),

                              Container(

                                padding:
                                    const EdgeInsets.symmetric(

                                  horizontal: 10,

                                  vertical: 5,

                                ),

                                decoration: BoxDecoration(

                                  color: riskColor(
                                          zone["risk"]!)
                                      .withValues(alpha: 0.15),

                                  borderRadius:
                                      BorderRadius.circular(20),

                                ),

                                child: Text(

                                  zone["risk"]!,

                                  style: TextStyle(

                                    color: riskColor(
                                        zone["risk"]!),

                                    fontWeight:
                                        FontWeight.bold,

                                  ),

                                ),

                              ),

                            ],

                          ),

                          const SizedBox(height: 15),

                          Row(

                            children: [

                              const Icon(
                                Icons.place,
                                color: Colors.blue,
                                size: 18,
                              ),

                              const SizedBox(width: 6),

                              Text(zone["location"]!),

                            ],

                          ),

                          const SizedBox(height: 8),

                          Row(

                            children: [

                              const Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 18,
                              ),

                              const SizedBox(width: 6),

                              Text(
                                "Status : ${zone["status"]}",
                              ),

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

                                  ScaffoldMessenger.of(
                                          context)
                                      .showSnackBar(

                                    SnackBar(

                                      content: Text(
                                          "Edit ${zone["name"]}"),

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
                                            "Delete Safe Zone"),

                                        content: Text(
                                            "Delete ${zone["name"]}?"),

                                        actions: [

                                          TextButton(

                                            onPressed: () {

                                              Navigator.pop(
                                                  context);

                                            },

                                            child: const Text(
                                                "Cancel"),

                                          ),

                                          ElevatedButton(

                                            style:
                                                ElevatedButton
                                                    .styleFrom(

                                              backgroundColor:
                                                  Colors.red,

                                            ),

                                            onPressed: () {

                                              setState(() {

                                                safeZones
                                                    .removeAt(
                                                        index);

                                              });

                                              Navigator.pop(
                                                  context);

                                            },

                                            child: const Text(

                                              "Delete",

                                              style: TextStyle(
                                                  color: Colors
                                                      .white),

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