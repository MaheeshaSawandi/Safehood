import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'predict_screen.dart';
import 'emergency_screen.dart';
import 'profile_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  int currentIndex = 1;

  GoogleMapController? mapController;

  final TextEditingController searchController = TextEditingController();

  final Set<Marker> _markers = {};

  String? searchedLocationName;
  LatLng? searchedLocationPosition;

  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(6.9271, 79.8612),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    addSampleMarkers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void addSampleMarkers() {
    _markers.addAll({
      const Marker(
        markerId: MarkerId("safe1"),
        position: LatLng(6.9271, 79.8612),
        infoWindow: InfoWindow(title: "Safe Zone"),
      ),
      const Marker(
        markerId: MarkerId("safe2"),
        position: LatLng(6.9305, 79.8585),
        infoWindow: InfoWindow(title: "Police Station"),
      ),
      const Marker(
        markerId: MarkerId("safe3"),
        position: LatLng(6.9250, 79.8650),
        infoWindow: InfoWindow(title: "Hospital"),
      ),
    });
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enable GPS."),
        ),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Location permission denied."),
        ),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    LatLng current = LatLng(position.latitude, position.longitude);

    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(current, 16),
    );

    setState(() {
      _markers.removeWhere(
        (marker) => marker.markerId.value == "current",
      );

      _markers.add(
        Marker(
          markerId: const MarkerId("current"),
          position: current,
          infoWindow: const InfoWindow(title: "You are here"),
        ),
      );
    });
  }

  Future<void> searchLocation(String address) async {
    if (address.trim().isEmpty) return;

    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No matching location found."),
          ),
        );
        return;
      }

      final location = locations.first;

      LatLng searched = LatLng(
        location.latitude,
        location.longitude,
      );

      searchedLocationName = address;
      searchedLocationPosition = searched;

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(searched, 16),
      );

      setState(() {
        _markers.removeWhere(
          (marker) => marker.markerId.value == "search",
        );

        _markers.add(
          Marker(
            markerId: const MarkerId("search"),
            position: searched,
            infoWindow: InfoWindow(title: address),
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No matching location found."),
        ),
      );
    }
  }

  Future<void> saveFavourite() async {
    if (searchedLocationName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Search a location first"),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    List<String> favourites = prefs.getStringList("favourites") ?? [];

    if (!favourites.contains(searchedLocationName)) {
      favourites.add(searchedLocationName!);

      await prefs.setStringList(
        "favourites",
        favourites,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Saved to favourites ⭐"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Already saved"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: initialPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: _markers,
              onMapCreated: (controller) {
                mapController = controller;
              },
            ),

            // Search bar
            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onSubmitted: searchLocation,
                  decoration: const InputDecoration(
                    hintText: "Search safe zones...",
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.location_on),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            // Favourite (Star) button
            Positioned(
              right: 20,
              bottom: 150,
              child: FloatingActionButton(
                backgroundColor: Colors.orange,
                onPressed: saveFavourite,
                child: const Icon(
                  Icons.star,
                  color: Colors.white,
                ),
              ),
            ),

            // Current location button
            Positioned(
              right: 20,
              bottom: 80,
              child: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: getCurrentLocation,
                child: const Icon(Icons.my_location),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == currentIndex) return;

          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                ),
              );
              break;

            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const PredictScreen(),
                ),
              );
              break;

            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const EmergencyScreen(),
                ),
              );
              break;

            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProfileScreen(),
                ),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
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
}