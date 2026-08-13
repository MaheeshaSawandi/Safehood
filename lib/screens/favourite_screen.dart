import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home_screen.dart';
import 'map_screen.dart';
import 'predict_screen.dart';
import 'emergency_screen.dart';
import 'profile_screen.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() =>
      _FavouriteScreenState();
}

class _FavouriteScreenState
    extends State<FavouriteScreen> {

  final SupabaseClient supabase =
      Supabase.instance.client;

  final int _currentIndex = -1;

  List<Map<String, dynamic>> savedLocations = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    loadFavouriteLocations();
  }

  // ============================================================
  // GET FIREBASE UID
  // ============================================================

  String? getFirebaseUid() {
    final firebase_auth.User? user =
        firebase_auth.FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint(
        "NO FIREBASE USER LOGGED IN",
      );

      return null;
    }

    debugPrint(
      "FIREBASE UID: ${user.uid}",
    );

    return user.uid;
  }

  // ============================================================
  // LOAD FAVOURITES
  // ============================================================

  Future<void> loadFavouriteLocations() async {
    final firebase_auth.User? user =
        firebase_auth.FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint(
        "LOAD ERROR: NO FIREBASE USER LOGGED IN",
      );

      if (!mounted) return;

      setState(() {
        savedLocations = [];
        isLoading = false;
      });

      return;
    }

    final String firebaseUid =
        user.uid;

    debugPrint(
      "LOADING FAVOURITES FOR UID: $firebaseUid",
    );

    try {
      final data = await supabase
          .from('favourites')
          .select()
          .eq('user_id', firebaseUid)
          .order(
            'created_at',
            ascending: false,
          );

      debugPrint(
        "FAVOURITES FROM SUPABASE: $data",
      );

      if (!mounted) return;

      setState(() {
        savedLocations =
            List<Map<String, dynamic>>.from(
          data,
        );

        isLoading = false;
      });
    } catch (e) {
      debugPrint(
        "LOAD FAVOURITES ERROR: $e",
      );

      if (!mounted) return;

      setState(() {
        savedLocations = [];
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error loading favourites: $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // DELETE FAVOURITE
  // ============================================================

  Future<void> removeFavourite(
    Map<String, dynamic> favourite,
  ) async {
    final firebase_auth.User? user =
        firebase_auth.FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint(
        "DELETE ERROR: NO FIREBASE USER",
      );

      return;
    }

    final String firebaseUid =
        user.uid;

    final dynamic id =
        favourite['id'];

    debugPrint(
      "DELETE FAVOURITE ID: $id",
    );

    debugPrint(
      "DELETE USER UID: $firebaseUid",
    );

    try {
      await supabase
          .from('favourites')
          .delete()
          .eq('id', id)
          .eq('user_id', firebaseUid);

      debugPrint(
        "FAVOURITE DELETED",
      );

      await loadFavouriteLocations();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Favourite removed",
          ),
        ),
      );
    } catch (e) {
      debugPrint(
        "DELETE FAVOURITE ERROR: $e",
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Error removing favourite: $e",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _onTabTapped(int index) {
    if (index == _currentIndex) {
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

      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const MapScreen(),
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
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xffF5F7FB),

      appBar: AppBar(
        elevation: 0,

        backgroundColor:
            Colors.white,

        foregroundColor:
            Colors.black,

        title: const Text(
          "Favourite Places",
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed:
                loadFavouriteLocations,
            icon:
                const Icon(Icons.refresh),
          ),
        ],
      ),

      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : ListView(
              padding:
                  const EdgeInsets.all(18),

              children: [
                const Text(
                  "Saved Favourite Locations",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                // ==================================================
                // EMPTY STATE
                // ==================================================

                savedLocations.isEmpty
                    ? const Padding(
                        padding:
                            EdgeInsets.all(30),

                        child: Center(
                          child: Text(
                            "No favourite locations saved yet",
                            style: TextStyle(
                              color:
                                  Colors.grey,
                            ),
                          ),
                        ),
                      )

                    // ==================================================
                    // FAVOURITE LIST
                    // ==================================================

                    : Column(
                        children:
                            savedLocations
                                .map(
                                  (
                                    favourite,
                                  ) {
                                    final String place =
                                        favourite['place_name'] ??
                                            'Unknown location';

                                    return Card(
                                      margin:
                                          const EdgeInsets.only(
                                        bottom:
                                            12,
                                      ),

                                      shape:
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                          16,
                                        ),
                                      ),

                                      child:
                                          ListTile(
                                        leading:
                                            const CircleAvatar(
                                          backgroundColor:
                                              Color(
                                            0xffE3F2FD,
                                          ),
                                          child:
                                              Icon(
                                            Icons.location_on,
                                            color:
                                                Colors.blue,
                                          ),
                                        ),

                                        title:
                                            Text(
                                          place,
                                          style:
                                              const TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                          ),
                                        ),

                                        subtitle:
                                            Text(
                                          "Latitude: ${favourite['latitude'] ?? '-'}\nLongitude: ${favourite['longitude'] ?? '-'}",
                                        ),

                                        trailing:
                                            IconButton(
                                          icon:
                                              const Icon(
                                            Icons.delete,
                                            color:
                                                Colors.red,
                                          ),

                                          onPressed:
                                              () {
                                            removeFavourite(
                                              favourite,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                )
                                .toList(),
                      ),

                const SizedBox(
                  height: 25,
                ),

                // ==================================================
                // SAFE ZONES
                // ==================================================

                const Text(
                  "Saved Safe Zones",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

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

      bottomNavigationBar:
          BottomNavigationBar(
        currentIndex:
            _currentIndex < 0
                ? 0
                : _currentIndex,

        type:
            BottomNavigationBarType.fixed,

        selectedItemColor:
            Colors.blue,

        unselectedItemColor:
            Colors.grey,

        onTap:
            _onTabTapped,

        items: const [
          BottomNavigationBarItem(
            icon:
                Icon(Icons.home),
            label:
                "Home",
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.map),
            label:
                "Map",
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.analytics),
            label:
                "Predict",
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.phone),
            label:
                "Emergency",
          ),

          BottomNavigationBarItem(
            icon:
                Icon(Icons.person),
            label:
                "Profile",
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SAFE ZONE CARD
  // ============================================================

  Widget safeZoneCard(
    String place,
    String risk,
    Color color,
  ) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 12,
      ),

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: ListTile(
        leading:
            Icon(
          Icons.shield,
          color: color,
        ),

        title:
            Text(
          place,
          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        subtitle:
            Text(risk),

        trailing:
            Icon(
          Icons.circle,
          size: 14,
          color: color,
        ),
      ),
    );
  }
}