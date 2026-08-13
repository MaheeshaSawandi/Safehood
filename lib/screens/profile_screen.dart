import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home_screen.dart';
import 'map_screen.dart';
import 'predict_screen.dart';
import 'emergency_screen.dart';
import 'adminlogin_screen.dart';
import 'settings_screen.dart';
import 'personalinformation_screen.dart';
import 'security_screen.dart';
import 'notifications_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentIndex = 4;

  final SupabaseClient supabase = Supabase.instance.client;

  // Emergency contacts
  String contact1Name = "Spouse";
  String contact1Phone = "+94 77 123 4567";
  String contact2Name = "Home Address";
  String contact2Phone = "123, Lotus Road, Colombo 07";

  @override
  void initState() {
    super.initState();
    loadEmergencyContacts();
  }

  // ========== Load saved contacts (from Supabase) ==========
  Future<void> loadEmergencyContacts() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) return;

    try {
      final data = await supabase
          .from('personal_emergency_contacts')
          .select()
          .eq('user_id', uid)
          .maybeSingle();

      debugPrint("EMERGENCY CONTACTS FROM SUPABASE: $data");

      if (!mounted) return;

      if (data != null) {
        setState(() {
          contact1Name = data["contact1_name"] ?? "Spouse";
          contact1Phone = data["contact1_phone"] ?? "+94 77 123 4567";
          contact2Name = data["contact2_name"] ?? "Home Address";
          contact2Phone =
              data["contact2_phone"] ?? "123, Lotus Road, Colombo 07";
        });
      }
      // if no row exists yet, keep the default values already set above
    } catch (e) {
      debugPrint("LOAD EMERGENCY CONTACTS ERROR: $e");
    }
  }

  // ========== Save contacts (to Supabase) ==========
  Future<void> saveEmergencyContacts() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("You must be logged in to save contacts"),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      await supabase.from('personal_emergency_contacts').upsert(
        {
          'user_id': uid,
          'contact1_name': contact1Name,
          'contact1_phone': contact1Phone,
          'contact2_name': contact2Name,
          'contact2_phone': contact2Phone,
          'updated_at': DateTime.now().toIso8601String(),
        },
        onConflict: 'user_id',
      );

      debugPrint("EMERGENCY CONTACTS SAVED FOR: $uid");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Emergency contacts saved ✔"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint("SAVE EMERGENCY CONTACTS ERROR: $e");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving contacts: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ========== Make phone call ==========
  Future<void> makePhoneCall(String phoneNumber) async {
    final cleaned = phoneNumber.replaceAll(" ", "");

    final Uri launchUri = Uri(
      scheme: 'tel',
      path: cleaned,
    );

    try {
      final canLaunch = await canLaunchUrl(launchUri);

      if (!mounted) return;

      if (canLaunch) {
        await launchUrl(launchUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not call $phoneNumber")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error making phone call")),
      );
    }
  }

  // ========== Edit contact dialog ==========
  void showEditContactDialog({
    required int contactNumber,
    required String currentName,
    required String currentPhone,
  }) {
    final nameController = TextEditingController(text: currentName);
    final phoneController = TextEditingController(text: currentPhone);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            contactNumber == 1 ? "Edit Contact 1" : "Edit Home Address",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: contactNumber == 1 ? "Name / Label" : "Label",
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(
                    contactNumber == 1 ? Icons.person : Icons.home,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: contactNumber == 1
                    ? TextInputType.phone
                    : TextInputType.streetAddress,
                decoration: InputDecoration(
                  labelText:
                      contactNumber == 1 ? "Phone Number" : "Address",
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(
                    contactNumber == 1 ? Icons.phone : Icons.location_on,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (contactNumber == 1) {
                    contact1Name = nameController.text.trim();
                    contact1Phone = phoneController.text.trim();
                  } else {
                    contact2Name = nameController.text.trim();
                    contact2Phone = phoneController.text.trim();
                  }
                });

                saveEmergencyContacts();
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 110,
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color(0xff2856A6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "My Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Column(
                  children: [
                    // Profile card
                    // FIX: removed the fixed `height: 75`, which was too
                    // small for the row's actual content (the PopupMenuButton's
                    // default tap target made the row taller than 75px and
                    // caused a "bottom overflowed by 3.9 pixels" error).
                    // Letting the container size to its content, and shrinking
                    // the PopupMenuButton's hit target, fixes it cleanly.
                    Transform.translate(
                      offset: const Offset(0, -20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 38,
                              width: 38,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: Colors.grey.shade500,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        "User",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        // FIX: shrink the button's tap target
                                        // so it doesn't force the row taller
                                        // than the card can fit.
                                        constraints: const BoxConstraints(
                                          maxHeight: 22,
                                          maxWidth: 22,
                                        ),
                                        iconSize: 18,
                                        splashRadius: 14,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 18,
                                        ),
                                        onSelected: (value) {
                                          if (value == "admin") {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const AdminLoginScreen(),
                                              ),
                                            );
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: "admin",
                                            child: Text("Admin"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "user@example.com",
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Account section
                    profileSection(
                      title: "Account",
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const PersonalInformationScreen(),
                              ),
                            );
                          },
                          child: profileTile(
                            Icons.person_outline,
                            "Personal Information",
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SecurityScreen(),
                              ),
                            );
                          },
                          child: profileTile(
                            Icons.shield_outlined,
                            "Security & Privacy",
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationsScreen(),
                              ),
                            );
                          },
                          child: profileTile(
                            Icons.notifications_none,
                            "Notifications",
                          ),
                        ),
                      ],
                    ),

                    // ========== Emergency Contacts ==========
                    profileSection(
                      title: "Emergency Contacts",
                      children: [
                        // Contact 1 - Phone (with Call button)
                        emergencyContactTile(
                          name: contact1Name,
                          phone: contact1Phone,
                          showCall: true,
                          onEdit: () {
                            showEditContactDialog(
                              contactNumber: 1,
                              currentName: contact1Name,
                              currentPhone: contact1Phone,
                            );
                          },
                          onCall: () {
                            makePhoneCall(contact1Phone);
                          },
                        ),

                        // Contact 2 - Home Address (NO Call button)
                        emergencyContactTile(
                          name: contact2Name,
                          phone: contact2Phone,
                          showCall: false, // ← no call for address
                          onEdit: () {
                            showEditContactDialog(
                              contactNumber: 2,
                              currentName: contact2Name,
                              currentPhone: contact2Phone,
                            );
                          },
                          onCall: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Logout button
                    Container(
                      height: 42,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton.icon(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();

                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.red,
                          size: 17,
                        ),
                        label: const Text(
                          "Log Out",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
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
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics), label: "Predict"),
          BottomNavigationBarItem(icon: Icon(Icons.phone), label: "Emergency"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // ========== Reusable widgets ==========

  Widget profileSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget profileTile(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 12)),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            size: 12,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  // Emergency contact tile
  Widget emergencyContactTile({
    required String name,
    required String phone,
    required bool showCall,
    required VoidCallback onEdit,
    required VoidCallback onCall,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              showCall ? Icons.contact_phone : Icons.home,
              size: 16,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  phone,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Call button only for phone contacts
          if (showCall)
            IconButton(
              icon: const Icon(Icons.phone, color: Colors.green, size: 20),
              onPressed: onCall,
              tooltip: "Call",
            ),

          // Edit button (always available)
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
            onPressed: onEdit,
            tooltip: "Edit",
          ),
        ],
      ),
    );
  }
}