import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {

  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> users = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // ============================================================
  // FETCH USERS FROM SUPABASE (personal_information table)
  // Registration/login is handled by Firebase Auth, but every
  // signed-up user's profile is already upserted into this table
  // ============================================================

  Future<void> fetchUsers() async {
    try {
      final data = await supabase
          .from('personal_information')
          .select()
          .order('created_at', ascending: false);

      debugPrint("USERS FROM SUPABASE: $data");

      if (!mounted) return;

      setState(() {
        users = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("FETCH USERS ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading users: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // DELETE USER PROFILE FROM SUPABASE
  // NOTE: this only removes the profile row. Deleting the actual
  // Firebase Auth account requires the Firebase Admin SDK
  // (e.g. via a Cloud Function) and cannot be done from the app.
  // ============================================================

  Future<void> deleteUser(int index) async {
    final user = users[index];

    try {
      await supabase
          .from('personal_information')
          .delete()
          .eq('user_id', user['user_id']);

      debugPrint("USER PROFILE DELETED: ${user['user_id']}");

      if (!mounted) return;

      setState(() {
        users.removeAt(index);
      });
    } catch (e) {
      debugPrint("DELETE USER ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting user: $e"),
          backgroundColor: Colors.red,
        ),
      );
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
          "Manage Users",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            onPressed: fetchUsers,
            icon: const Icon(Icons.refresh),
          ),
        ],

      ),

      floatingActionButton: FloatingActionButton(

        backgroundColor: Colors.blue,

        child: const Icon(Icons.person_add,color: Colors.white),

        onPressed: () {

          ScaffoldMessenger.of(context).showSnackBar(

            const SnackBar(
              content: Text("Add User Clicked"),
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

                hintText: "Search users...",

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

              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : users.isEmpty
                      ? const Center(
                          child: Text(
                            "No users found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(

                itemCount: users.length,

                itemBuilder: (context,index){

                  final user = users[index];

                  return Card(

                    elevation: 3,

                    margin: const EdgeInsets.only(bottom:15),

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(15),

                    ),

                    child: Padding(

                      padding: const EdgeInsets.all(15),

                      child: Row(

                        children: [

                          CircleAvatar(

                            radius: 28,

                            backgroundColor: Colors.blue.shade100,

                            child: const Icon(

                              Icons.person,

                              color: Colors.blue,

                              size: 30,

                            ),

                          ),

                          const SizedBox(width:15),

                          Expanded(

                            child: Column(

                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                Text(

                                  user["full_name"] ?? "Unnamed User",

                                  style: const TextStyle(

                                    fontWeight: FontWeight.bold,

                                    fontSize: 16,

                                  ),

                                ),

                                const SizedBox(height:5),

                                Text(user["email"] ?? "-"),

                                const SizedBox(height:3),

                                Text(

                                  user["phone"] ?? "-",

                                  style: TextStyle(

                                    color: Colors.grey.shade700,

                                  ),

                                ),

                              ],

                            ),

                          ),

                          Column(

                            children: [

                              IconButton(

                                icon: const Icon(

                                  Icons.edit,

                                  color: Colors.orange,

                                ),

                                onPressed: () {

                                  ScaffoldMessenger.of(context).showSnackBar(

                                    SnackBar(

                                      content: Text(
                                          "Edit ${user["full_name"] ?? "user"}"),
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

                                        title: const Text("Delete User"),

                                        content: Text(

                                          "Delete ${user["full_name"] ?? "this user"} ?",

                                        ),

                                        actions: [

                                          TextButton(

                                            onPressed: () {

                                              Navigator.pop(context);

                                            },

                                            child: const Text("Cancel"),

                                          ),

                                          ElevatedButton(

                                            style: ElevatedButton.styleFrom(

                                              backgroundColor: Colors.red,

                                            ),

                                            onPressed: () async {

                                              Navigator.pop(context);

                                              await deleteUser(index);

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