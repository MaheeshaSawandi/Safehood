import 'package:flutter/material.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {

  final List<Map<String, String>> users = [

    {
      "name": "John Smith",
      "email": "john@gmail.com",
      "phone": "+94 71 123 4567"
    },

    {
      "name": "Emily Johnson",
      "email": "emily@gmail.com",
      "phone": "+94 77 654 3210"
    },

    {
      "name": "David Brown",
      "email": "david@gmail.com",
      "phone": "+94 76 555 1234"
    },

    {
      "name": "Sarah Wilson",
      "email": "sarah@gmail.com",
      "phone": "+94 75 888 7777"
    },

  ];

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

              child: ListView.builder(

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

                                  user["name"]!,

                                  style: const TextStyle(

                                    fontWeight: FontWeight.bold,

                                    fontSize: 16,

                                  ),

                                ),

                                const SizedBox(height:5),

                                Text(user["email"]!),

                                const SizedBox(height:3),

                                Text(

                                  user["phone"]!,

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
                                          "Edit ${user["name"]}"),
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

                                          "Delete ${user["name"]} ?",

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

                                            onPressed: () {

                                              setState(() {

                                                users.removeAt(index);

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