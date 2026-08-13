import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_screen.dart';
import 'map_screen.dart';
import 'predict_screen.dart';
import 'profile_screen.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  int selectedCategory = 0;
  String userArea = "Detecting location...";

  final List<String> categories = [
    "All",
    "Police",
    "Hospital",
    "Fire",
  ];

  List<Map<String, String>> emergencyList = [];

  // ========== Colombo data (default) ==========
  final List<Map<String, String>> colomboData = [
    {
      "type": "Hospital",
      "name": "Colombo General Hospital",
      "distance": "2.4 km",
      "phone": "0112691111",
    },
    {
      "type": "Police",
      "name": "Kollupitiya Police Station",
      "distance": "1.8 km",
      "phone": "0112433333",
    },
    {
      "type": "Fire",
      "name": "Colombo Fire Station",
      "distance": "3.2 km",
      "phone": "110",
    },
  ];

  // ========== Anuradhapura data ==========
  final List<Map<String, String>> anuradhapuraData = [
    {
      "type": "Hospital",
      "name": "Anuradhapura Teaching Hospital",
      "distance": "1.5 km",
      "phone": "0252222261",
    },
    {
      "type": "Police",
      "name": "Anuradhapura Police Station",
      "distance": "2.0 km",
      "phone": "0252222222",
    },
    {
      "type": "Fire",
      "name": "Anuradhapura Fire Brigade",
      "distance": "3.0 km",
      "phone": "110",
    },
    {
      "type": "Fire",
      "name": "Emergency Fire Service",
      "distance": "0 km",
      "phone": "1990",
    },
  ];

  // ========== Mihinthale data ==========
  final List<Map<String, String>> mihinthaleData = [
    {
      "type": "Hospital",
      "name": "Mihinthale Base Hospital",
      "distance": "1.2 km",
      "phone": "0252266122",
    },
    {
      "type": "Hospital",
      "name": "Anuradhapura Teaching Hospital",
      "distance": "12 km",
      "phone": "0252222261",
    },
    {
      "type": "Police",
      "name": "Mihinthale Police Station",
      "distance": "0.8 km",
      "phone": "0252266222",
    },
    {
      "type": "Police",
      "name": "Anuradhapura Police Station",
      "distance": "13 km",
      "phone": "0252222222",
    },
    {
      "type": "Fire",
      "name": "Mihinthale Fire Service",
      "distance": "1.5 km",
      "phone": "110",
    },
    {
      "type": "Fire",
      "name": "Emergency Ambulance / Fire",
      "distance": "0 km",
      "phone": "1990",
    },
  ];

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  // ========== Make a real phone call ==========
  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not call $phoneNumber")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error making phone call")),
      );
    }
  }

  // ========== Detect user's area ==========
  Future<void> getUserLocation() async {
    bool service = await Geolocator.isLocationServiceEnabled();

    if (!service) {
      setState(() {
        userArea = "Location disabled";
        emergencyList = colomboData;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        userArea = "Permission denied";
        emergencyList = colomboData;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    double lat = position.latitude;
    double lon = position.longitude;

    // Mihinthale
    if (lat > 8.30 && lat < 8.40 && lon > 80.45 && lon < 80.55) {
      setState(() {
        userArea = "Mihinthale";
        emergencyList = mihinthaleData;
      });
    }
    // Anuradhapura
    else if (lat > 8.25 && lat < 8.40 && lon > 80.35 && lon < 80.45) {
      setState(() {
        userArea = "Anuradhapura";
        emergencyList = anuradhapuraData;
      });
    }
    // Default → Colombo / Other
    else {
      setState(() {
        userArea = "Other Area";
        emergencyList = colomboData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: SafeArea(
        child: Column(
          children: [
            // ========== HEADER ==========
            Container(
              height: 120,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color(0xffF65A5A),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Emergency Help",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Current Area : $userArea",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 35,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // SOS → calls national emergency number
                        makePhoneCall("1990");
                      },
                      icon: const Icon(
                        Icons.phone,
                        color: Colors.red,
                      ),
                      label: const Text(
                        "SOS CALL NOW",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ========== CATEGORY FILTER ==========
            SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: selectedCategory == index
                            ? Colors.blue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: selectedCategory == index
                                ? Colors.white
                                : Colors.grey,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // ========== EMERGENCY LIST ==========
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: emergencyList.length,
                itemBuilder: (context, index) {
                  var item = emergencyList[index];

                  if (selectedCategory != 0 &&
                      item["type"] != categories[selectedCategory]) {
                    return const SizedBox.shrink();
                  }

                  return emergencyCard(
                    item["type"]!,
                    item["name"]!,
                    item["distance"]!,
                    item["phone"]!,
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MapScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PredictScreen()),
            );
          } else if (index == 4) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: "Predict",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.phone),
            label: "Emergency",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  // ========== EMERGENCY CARD ==========
  Widget emergencyCard(
    String type,
    String name,
    String distance,
    String phone,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade50,
          child: Icon(
            type == "Hospital"
                ? Icons.local_hospital
                : type == "Police"
                    ? Icons.local_police
                    : Icons.fire_truck,
            color: Colors.red,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          "$distance\nEmergency : $phone",
          style: const TextStyle(fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.phone,
            color: Colors.blue,
          ),
          onPressed: () {
            makePhoneCall(phone); // ← real call
          },
        ),
      ),
    );
  }
}