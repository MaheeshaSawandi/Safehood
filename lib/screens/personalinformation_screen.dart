import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:supabase_flutter/supabase_flutter.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState
    extends State<PersonalInformationScreen> {
  // ================= SUPABASE =================

  final supabase = Supabase.instance.client;

  // ================= FIREBASE =================

  firebase_auth.User? get firebaseUser =>
      firebase_auth.FirebaseAuth.instance.currentUser;

  // Firebase UID of currently logged-in user
  String? get firebaseUid => firebaseUser?.uid;

  // ================= UI VARIABLES =================

  bool isEditing = false;
  bool isLoading = true;
  bool isSaving = false;

  File? profileImage;

  // ================= CONTROLLERS =================

  final nameController = TextEditingController(text: "John Doe");

  final emailController =
      TextEditingController(text: "john@example.com");

  final phoneController =
      TextEditingController(text: "+94 77 123 4567");

  final genderController =
      TextEditingController(text: "Male");

  final dobController =
      TextEditingController(text: "12 March 2002");

  final addressController =
      TextEditingController(text: "Colombo 07, Sri Lanka");

  final ImagePicker _picker = ImagePicker();

  // ================= INIT =================

  @override
  void initState() {
    super.initState();

    fetchUserData();
  }

  // ================= DISPOSE =================

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    genderController.dispose();
    dobController.dispose();
    addressController.dispose();

    super.dispose();
  }

  // ============================================================
  // GET FIREBASE USER UID
  // ============================================================

  String? getCurrentFirebaseUid() {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;

    if (user == null) {
      debugPrint("NO FIREBASE USER LOGGED IN");
      return null;
    }

    debugPrint("====================================");
    debugPrint("FIREBASE USER UID: ${user.uid}");
    debugPrint("FIREBASE USER EMAIL: ${user.email}");
    debugPrint("====================================");

    return user.uid;
  }

  // ============================================================
  // FETCH DATA FROM SUPABASE
  // ============================================================

  Future<void> fetchUserData() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      // Get Firebase UID
      final uid = getCurrentFirebaseUid();

      // If no Firebase user
      if (uid == null) {
        debugPrint("FETCH ERROR: No Firebase user logged in");

        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }

        return;
      }

      debugPrint("FETCHING SUPABASE DATA FOR UID: $uid");

      // Get user's row from Supabase
      final data = await supabase
          .from('personal_information')
          .select()
          .eq('user_id', uid)
          .maybeSingle();

      // No row exists yet
      if (data == null) {
        debugPrint("NO PROFILE FOUND FOR THIS FIREBASE USER");

        // Use Firebase email if available
        if (firebaseUser?.email != null &&
            firebaseUser!.email!.isNotEmpty) {
          emailController.text = firebaseUser!.email!;
        }

        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }

        return;
      }

      debugPrint("SUPABASE PROFILE FOUND:");
      debugPrint(data.toString());

      // Put database data into controllers
      if (mounted) {
        setState(() {
          nameController.text =
              data['full_name']?.toString() ?? '';

          emailController.text =
              data['email']?.toString() ??
                  firebaseUser?.email ??
                  '';

          phoneController.text =
              data['phone']?.toString() ?? '';

          genderController.text =
              data['gender']?.toString() ?? '';

          dobController.text =
              data['date_of_birth']?.toString() ?? '';

          addressController.text =
              data['address']?.toString() ?? '';

          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("====================================");
      debugPrint("FETCH ERROR: $e");
      debugPrint("====================================");

      if (mounted) {
        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error loading information: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ============================================================
  // SAVE DATA TO SUPABASE
  // ============================================================

  Future<bool> saveUserData() async {
    try {
      setState(() {
        isSaving = true;
      });

      // Get Firebase UID
      final uid = getCurrentFirebaseUid();

      if (uid == null) {
        debugPrint("SAVE ERROR: No Firebase user logged in");

        if (mounted) {
          setState(() {
            isSaving = false;
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please login first."),
            backgroundColor: Colors.red,
          ),
        );

        return false;
      }

      debugPrint("====================================");
      debugPrint("SAVING DATA");
      debugPrint("FIREBASE UID: $uid");
      debugPrint("====================================");

      // Data that will be sent to Supabase
      final profileData = {
        'user_id': uid,
        'full_name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'gender': genderController.text.trim(),
        'date_of_birth': dobController.text.trim(),
        'address': addressController.text.trim(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      debugPrint("DATA BEING SENT:");
      debugPrint(profileData.toString());

      // Insert new row OR update existing row
      await supabase
          .from('personal_information')
          .upsert(
            profileData,
            onConflict: 'user_id',
          );

      debugPrint("====================================");
      debugPrint("DATA SAVED SUCCESSFULLY");
      debugPrint("FIREBASE UID: $uid");
      debugPrint("====================================");

      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }

      return true;
    } catch (e) {
      debugPrint("====================================");
      debugPrint("SAVE ERROR: $e");
      debugPrint("====================================");

      if (mounted) {
        setState(() {
          isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Save error: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }

      return false;
    }
  }

  // ============================================================
  // EDIT / SAVE BUTTON
  // ============================================================

  Future<void> toggleEdit() async {
    // Currently viewing -> enter edit mode
    if (!isEditing) {
      setState(() {
        isEditing = true;
      });

      return;
    }

    // Currently editing -> save
    final success = await saveUserData();

    if (!mounted) return;

    if (success) {
      setState(() {
        isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Information updated successfully"),
          backgroundColor: Colors.green,
        ),
      );

      // Reload from Supabase
      await fetchUserData();
    }
  }

  // ============================================================
  // PICK IMAGE
  // ============================================================

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error picking image: $e"),
        ),
      );
    }
  }

  // ============================================================
  // IMAGE OPTIONS
  // ============================================================

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Change Profile Photo",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                // Gallery
                ListTile(
                  leading: const Icon(
                    Icons.photo_library,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    "Choose from Gallery",
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),

                // Camera
                ListTile(
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Colors.blue,
                  ),
                  title: const Text(
                    "Take a Photo",
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),

                // Remove
                if (profileImage != null)
                  ListTile(
                    leading: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    title: const Text(
                      "Remove Photo",
                    ),
                    onTap: () {
                      Navigator.pop(context);

                      setState(() {
                        profileImage = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      // ================= APP BAR =================

      appBar: AppBar(
        title: const Text(
          "Personal Information",
        ),
        backgroundColor: const Color(0xff2856A6),
        foregroundColor: Colors.white,

        actions: [
          TextButton(
            onPressed: isSaving ? null : toggleEdit,
            child: Text(
              isEditing ? "Save" : "Edit",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),

      // ================= BODY =================

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(18),

              child: Column(
                children: [
                  // ================= PROFILE IMAGE =================

                  GestureDetector(
                    onTap: _showImageSourceOptions,

                    child: Stack(
                      children: [
                        Container(
                          height: 110,
                          width: 110,

                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: BoxShape.circle,

                            image: profileImage != null
                                ? DecorationImage(
                                    image:
                                        FileImage(profileImage!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),

                          child: profileImage == null
                              ? const Icon(
                                  Icons.person,
                                  size: 65,
                                  color: Colors.white,
                                )
                              : null,
                        ),

                        // Camera icon
                        Positioned(
                          bottom: 0,
                          right: 0,

                          child: Container(
                            height: 32,
                            width: 32,

                            decoration: BoxDecoration(
                              color:
                                  const Color(0xff2856A6),
                              shape: BoxShape.circle,

                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),

                            child: const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ================= CHANGE PHOTO =================

                  TextButton.icon(
                    onPressed: _showImageSourceOptions,
                    icon: const Icon(
                      Icons.camera_alt,
                    ),
                    label: const Text(
                      "Change Photo",
                    ),
                  ),

                  const SizedBox(height: 25),

                  // ================= FULL NAME =================

                  _buildField(
                    title: "Full Name",
                    controller: nameController,
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 12),

                  // ================= EMAIL =================

                  _buildField(
                    title: "Email",
                    controller: emailController,
                    icon: Icons.email_outlined,
                    keyboardType:
                        TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 12),

                  // ================= PHONE =================

                  _buildField(
                    title: "Phone Number",
                    controller: phoneController,
                    icon: Icons.phone_outlined,
                    keyboardType:
                        TextInputType.phone,
                  ),

                  const SizedBox(height: 12),

                  // ================= GENDER =================

                  _buildField(
                    title: "Gender",
                    controller: genderController,
                    icon: Icons.people_outline,
                  ),

                  const SizedBox(height: 12),

                  // ================= DOB =================

                  _buildField(
                    title: "Date of Birth",
                    controller: dobController,
                    icon: Icons.calendar_month,
                  ),

                  const SizedBox(height: 12),

                  // ================= ADDRESS =================

                  _buildField(
                    title: "Address",
                    controller: addressController,
                    icon: Icons.location_on_outlined,
                    maxLines: 2,
                  ),

                  const SizedBox(height: 30),

                  // ================= SAVE BUTTON =================

                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton.icon(
                      onPressed:
                          isSaving ? null : toggleEdit,

                      icon: Icon(
                        isSaving
                            ? Icons.hourglass_empty
                            : isEditing
                                ? Icons.save
                                : Icons.edit,
                      ),

                      label: Text(
                        isSaving
                            ? "Saving..."
                            : isEditing
                                ? "Save Information"
                                : "Edit Information",
                      ),

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xff2856A6),

                        foregroundColor:
                            Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // ============================================================
  // BUILD FIELD
  // ============================================================

  Widget _buildField({
    required String title,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType =
        TextInputType.text,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            color: Colors.blue,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 5),

                isEditing
                    ? TextField(
                        controller: controller,
                        keyboardType:
                            keyboardType,
                        maxLines: maxLines,

                        decoration:
                            const InputDecoration(
                          isDense: true,
                          border:
                              InputBorder.none,
                          contentPadding:
                              EdgeInsets.zero,
                        ),

                        style:
                            const TextStyle(
                          fontSize: 15,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      )
                    : Text(
                        controller.text,

                        style:
                            const TextStyle(
                          fontSize: 15,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}