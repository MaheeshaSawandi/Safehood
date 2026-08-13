import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:supabase_flutter/supabase_flutter.dart';

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

  final SupabaseClient supabase = Supabase.instance.client;

  String? searchedLocationName;
  LatLng? searchedLocationPosition;

  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(6.9271, 79.8612),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();

    debugPrint(
      "Firebase UID: ${firebase_auth.FirebaseAuth.instance.currentUser?.uid}",
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // GET FIREBASE UID
  // ============================================================

  String? getFirebaseUid() {
    final firebase_auth.User? user =
        firebase_auth.FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint("NO FIREBASE USER LOGGED IN");
      return null;
    }

    debugPrint("FIREBASE UID: ${user.uid}");

    return user.uid;
  }

  // ============================================================
  // CURRENT LOCATION
  // ============================================================

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enable GPS."),
          ),
        );

        return;
      }

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Location permission denied."),
          ),
        );

        return;
      }

      Position position =
          await Geolocator.getCurrentPosition();

      LatLng current = LatLng(
        position.latitude,
        position.longitude,
      );

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          current,
          16,
        ),
      );

      setState(() {
        _markers.removeWhere(
          (marker) =>
              marker.markerId.value == "current",
        );

        _markers.add(
          Marker(
            markerId: const MarkerId("current"),
            position: current,
            infoWindow: const InfoWindow(
              title: "You are here",
            ),
          ),
        );
      });
    } catch (e) {
      debugPrint("LOCATION ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Unable to get location: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // SEARCH LOCATION
  // ============================================================

  Future<void> searchLocation(String address) async {
    if (address.trim().isEmpty) {
      return;
    }

    try {
      List<Location> locations =
          await locationFromAddress(address);

      if (locations.isEmpty) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "No matching location found.",
            ),
          ),
        );

        return;
      }

      final location = locations.first;

      LatLng searched = LatLng(
        location.latitude,
        location.longitude,
      );

      searchedLocationName = address.trim();

      searchedLocationPosition = searched;

      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(
          searched,
          16,
        ),
      );

      setState(() {
        _markers.removeWhere(
          (marker) =>
              marker.markerId.value == "search",
        );

        _markers.add(
          Marker(
            markerId: const MarkerId("search"),
            position: searched,
            infoWindow: InfoWindow(
              title: address.trim(),
            ),
          ),
        );
      });

      debugPrint(
        "SEARCHED LOCATION: $searchedLocationName",
      );

      debugPrint(
        "LATITUDE: ${searched.latitude}",
      );

      debugPrint(
        "LONGITUDE: ${searched.longitude}",
      );
    } catch (e) {
      debugPrint("SEARCH ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "No matching location found.",
          ),
        ),
      );
    }
  }

  // ============================================================
  // SAVE FAVOURITE TO SUPABASE
  // ============================================================

  Future<void> saveFavourite() async {
    // Get Firebase user
    final firebase_auth.User? user =
        firebase_auth.FirebaseAuth.instance.currentUser;

    // Check login
    if (user == null) {
      debugPrint(
        "SAVE ERROR: NO FIREBASE USER LOGGED IN",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please login first.",
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    // Check location
    if (searchedLocationName == null ||
        searchedLocationName!.trim().isEmpty) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Search a location first.",
          ),
        ),
      );

      return;
    }

    final String firebaseUid = user.uid;

    debugPrint(
      "=================================",
    );

    debugPrint(
      "FIREBASE UID: $firebaseUid",
    );

    debugPrint(
      "PLACE: $searchedLocationName",
    );

    debugPrint(
      "LATITUDE: ${searchedLocationPosition?.latitude}",
    );

    debugPrint(
      "LONGITUDE: ${searchedLocationPosition?.longitude}",
    );

    debugPrint(
      "=================================",
    );

    try {
      await supabase
          .from('favourites')
          .upsert(
        {
          'user_id': firebaseUid,
          'place_name': searchedLocationName!.trim(),
          'latitude':
              searchedLocationPosition?.latitude,
          'longitude':
              searchedLocationPosition?.longitude,
        },
        onConflict: 'user_id,place_name',
      );

      debugPrint(
        "FAVOURITE SAVED SUCCESSFULLY",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Saved to favourites ⭐",
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint(
        "FAVOURITE SAVE ERROR: $e",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error saving favourite: $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
                  initialPosition,

              myLocationEnabled: true,

              myLocationButtonEnabled: false,

              markers: _markers,

              onMapCreated: (controller) {
                mapController = controller;
              },
            ),

            // ==================================================
            // SEARCH BAR
            // ==================================================

            Positioned(
              top: 15,
              left: 15,
              right: 15,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: TextField(
                  controller:
                      searchController,

                  onSubmitted:
                      searchLocation,

                  decoration:
                      const InputDecoration(
                    hintText:
                        "Search safe zones...",

                    prefixIcon:
                        Icon(Icons.search),

                    suffixIcon:
                        Icon(
                      Icons.location_on,
                    ),

                    border:
                        InputBorder.none,
                  ),
                ),
              ),
            ),

            // ==================================================
            // FAVOURITE BUTTON
            // ==================================================

            Positioned(
              right: 20,
              bottom: 150,
              child: FloatingActionButton(
                backgroundColor:
                    Colors.orange,

                onPressed:
                    saveFavourite,

                child: const Icon(
                  Icons.star,
                  color: Colors.white,
                ),
              ),
            ),

            // ==================================================
            // CURRENT LOCATION
            // ==================================================

            Positioned(
              right: 20,
              bottom: 80,
              child: FloatingActionButton(
                backgroundColor:
                    Colors.blue,

                onPressed:
                    getCurrentLocation,

                child: const Icon(
                  Icons.my_location,
                ),
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex: currentIndex,

        type:
            BottomNavigationBarType.fixed,

        onTap: (index) {
          if (index == currentIndex) {
            return;
          }

          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const HomeScreen(),
                ),
              );
              break;

            case 2:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const PredictScreen(),
                ),
              );
              break;

            case 3:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const EmergencyScreen(),
                ),
              );
              break;

            case 4:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const ProfileScreen(),
                ),
              );
              break;
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
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