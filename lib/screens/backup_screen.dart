import 'package:flutter/material.dart';

class BackupScreen extends StatefulWidget {
  const BackupScreen({super.key});

  @override
  State<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends State<BackupScreen> {

  bool backupCompleted = false;

  String backupDate = "No backup yet";

  Future<void> performBackup() async {

    await Future.delayed(const Duration(seconds: 2));

    setState(() {

      backupCompleted = true;

      backupDate = DateTime.now().toString();

    });

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content: Text("Backup completed successfully"),

        backgroundColor: Colors.green,

      ),

    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(

        title: const Text("Backup Data"),

        backgroundColor: const Color(0xff2856A6),

        foregroundColor: Colors.white,

      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          children: [

            Container(

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius: BorderRadius.circular(18),

                boxShadow: [

                  BoxShadow(

                    color: Colors.grey.shade300,

                    blurRadius: 8,

                  )

                ],

              ),

              child: Column(

                children: [

                  const Icon(

                    Icons.backup,

                    size: 70,

                    color: Colors.blue,

                  ),

                  const SizedBox(height: 15),

                  const Text(

                    "System Backup",

                    style: TextStyle(

                      fontSize: 20,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                  const SizedBox(height: 10),

                  const Text(

                    "Backup Users, Alerts, Safe Zones, Crime Reports and System Settings.",

                    textAlign: TextAlign.center,

                    style: TextStyle(

                      color: Colors.grey,

                    ),

                  ),

                  const SizedBox(height: 25),

                  SizedBox(

                    width: double.infinity,

                    child: ElevatedButton.icon(

                      onPressed: performBackup,

                      icon: const Icon(Icons.cloud_upload),

                      label: const Text("Create Backup"),

                      style: ElevatedButton.styleFrom(

                        backgroundColor: Colors.blue,

                        foregroundColor: Colors.white,

                        padding: const EdgeInsets.symmetric(vertical: 14),

                      ),

                    ),

                  ),

                ],

              ),

            ),

            const SizedBox(height: 25),

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(

                color: Colors.white,

                borderRadius: BorderRadius.circular(15),

              ),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  const Text(

                    "Backup Status",

                    style: TextStyle(

                      fontWeight: FontWeight.bold,

                      fontSize: 16,

                    ),

                  ),

                  const SizedBox(height: 12),

                  Row(

                    children: [

                      Icon(

                        backupCompleted

                            ? Icons.check_circle

                            : Icons.cancel,

                        color: backupCompleted

                            ? Colors.green

                            : Colors.red,

                      ),

                      const SizedBox(width: 10),

                      Text(

                        backupCompleted

                            ? "Backup Completed"

                            : "No Backup",

                      ),

                    ],

                  ),

                  const SizedBox(height: 15),

                  Text(

                    "Last Backup",

                    style: TextStyle(

                      color: Colors.grey.shade700,

                    ),

                  ),

                  const SizedBox(height: 5),

                  Text(

                    backupDate,

                    style: const TextStyle(

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                ],

              ),

            ),

          ],

        ),

      ),

    );
  }
}