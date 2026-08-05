import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'map_screen.dart';
import 'predict_screen.dart';
import 'emergency_screen.dart';
import 'profile_screen.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final int _currentIndex = -1; // Fixed: not a bottom nav page

  List<String> savedLocations = [];

  @override
  void initState() {
    super.initState();
    loadFavouriteLocations();
  }

  Future<void> loadFavouriteLocations() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      savedLocations = prefs.getStringList("favourites") ?? [];
    });
  }

  Future<void> removeFavourite(String place) async {
    final prefs = await SharedPreferences.getInstance();

    savedLocations.remove(place);

    await prefs.setStringList(
      "favourites",
      savedLocations,
    );

    setState(() {});
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        break;

      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MapScreen()),
        );
        break;

      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PredictScreen()),
        );
        break;

      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const EmergencyScreen()),
        );
        break;

      case 4:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Favourite Places",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const Text(
            "Saved Favourite Locations",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          // Empty state or list of saved locations
          savedLocations.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(30),
                  child: Center(
                    child: Text(
                      "No favourite locations saved yet",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: savedLocations.map((place) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xffE3F2FD),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.blue,
                          ),
                        ),
                        title: Text(
                          place,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            removeFavourite(place);
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),

          const SizedBox(height: 25),

          const Text(
            "Saved Safe Zones",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),

          safeZoneCard(
            "Viharamahadevi Park",
            "Low Risk Area",
            Colors.green,
          ),
          safeZoneCard(
            "Independence Square",
            "Moderate Risk",
            Colors.orange,
          ),
          safeZoneCard(
            "Galle Face",
            "Low Risk Area",
            Colors.green,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex < 0 ? 0 : _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onTabTapped,
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

  Widget safeZoneCard(
    String place,
    String risk,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(
          Icons.shield,
          color: color,
        ),
        title: Text(
          place,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(risk),
        trailing: Icon(
          Icons.circle,
          size: 14,
          color: color,
        ),
      ),
    );
  }
}