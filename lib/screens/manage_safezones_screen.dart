import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageSafeZonesScreen extends StatefulWidget {
  const ManageSafeZonesScreen({super.key});

  @override
  State<ManageSafeZonesScreen> createState() =>
      _ManageSafeZonesScreenState();
}

class _ManageSafeZonesScreenState extends State<ManageSafeZonesScreen> {

  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> safeZones = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSafeZones();
  }

  // ============================================================
  // FETCH SAFE ZONES FROM SUPABASE
  // ============================================================

  Future<void> fetchSafeZones() async {
    try {
      final data = await supabase
          .from('safe_zones')
          .select()
          .order('created_at', ascending: false);

      debugPrint("SAFE ZONES FROM SUPABASE: $data");

      if (!mounted) return;

      setState(() {
        safeZones = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("FETCH SAFE ZONES ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading safe zones: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // DELETE SAFE ZONE FROM SUPABASE
  // ============================================================

  Future<void> deleteSafeZone(int index) async {
    final zone = safeZones[index];

    try {
      await supabase
          .from('safe_zones')
          .delete()
          .eq('id', zone['id']);

      debugPrint("SAFE ZONE DELETED: ${zone['id']}");

      if (!mounted) return;

      setState(() {
        safeZones.removeAt(index);
      });
    } catch (e) {
      debugPrint("DELETE SAFE ZONE ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting safe zone: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color riskColor(String risk) {
    switch (risk) {
      case "Very Safe":
        return Colors.green;
      case "Safe":
        return Colors.blue;
      default:
        return Colors.orange;
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
          "Manage Safe Zones",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            onPressed: fetchSafeZones,
            icon: const Icon(Icons.refresh),
          ),
        ],

      ),

      floatingActionButton: FloatingActionButton(

        backgroundColor: Colors.blue,

        child: const Icon(
          Icons.add_location_alt,
          color: Colors.white,
        ),

        onPressed: () {

          ScaffoldMessenger.of(context).showSnackBar(

            const SnackBar(
              content: Text("Add Safe Zone Clicked"),
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

                hintText: "Search Safe Zones...",

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
                  : safeZones.isEmpty
                      ? const Center(
                          child: Text(
                            "No safe zones found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(

                itemCount: safeZones.length,

                itemBuilder: (context, index) {

                  final zone = safeZones[index];

                  return Card(

                    elevation: 3,

                    margin: const EdgeInsets.only(bottom: 15),

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(15),

                    ),

                    child: Padding(

                      padding: const EdgeInsets.all(15),

                      child: Column(

                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          Row(

                            children: [

                              CircleAvatar(

                                radius: 25,

                                backgroundColor:
                                    Colors.green.shade100,

                                child: const Icon(

                                  Icons.location_on,

                                  color: Colors.green,

                                ),

                              ),

                              const SizedBox(width: 15),

                              Expanded(

                                child: Text(

                                  zone["name"]!,

                                  style: const TextStyle(

                                    fontSize: 17,

                                    fontWeight: FontWeight.bold,

                                  ),

                                ),

                              ),

                              Container(

                                padding:
                                    const EdgeInsets.symmetric(

                                  horizontal: 10,

                                  vertical: 5,

                                ),

                                decoration: BoxDecoration(

                                  color: riskColor(
                                          zone["risk"]!)
                                      .withValues(alpha: 0.15),

                                  borderRadius:
                                      BorderRadius.circular(20),

                                ),

                                child: Text(

                                  zone["risk"]!,

                                  style: TextStyle(

                                    color: riskColor(
                                        zone["risk"]!),

                                    fontWeight:
                                        FontWeight.bold,

                                  ),

                                ),

                              ),

                            ],

                          ),

                          const SizedBox(height: 15),

                          Row(

                            children: [

                              const Icon(
                                Icons.place,
                                color: Colors.blue,
                                size: 18,
                              ),

                              const SizedBox(width: 6),

                              Text(zone["location"]!),

                            ],

                          ),

                          const SizedBox(height: 8),

                          Row(

                            children: [

                              const Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 18,
                              ),

                              const SizedBox(width: 6),

                              Text(
                                "Status : ${zone["status"]}",
                              ),

                            ],

                          ),

                          const Divider(height: 25),

                          Row(

                            mainAxisAlignment:
                                MainAxisAlignment.end,

                            children: [

                              IconButton(

                                icon: const Icon(

                                  Icons.edit,

                                  color: Colors.orange,

                                ),

                                onPressed: () {

                                  ScaffoldMessenger.of(
                                          context)
                                      .showSnackBar(

                                    SnackBar(

                                      content: Text(
                                          "Edit ${zone["name"]}"),

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

                                        title: const Text(
                                            "Delete Safe Zone"),

                                        content: Text(
                                            "Delete ${zone["name"]}?"),

                                        actions: [

                                          TextButton(

                                            onPressed: () {

                                              Navigator.pop(
                                                  context);

                                            },

                                            child: const Text(
                                                "Cancel"),

                                          ),

                                          ElevatedButton(

                                            style:
                                                ElevatedButton
                                                    .styleFrom(

                                              backgroundColor:
                                                  Colors.red,

                                            ),

                                            onPressed: () async {

                                              Navigator.pop(
                                                  context);

                                              await deleteSafeZone(
                                                  index);

                                            },

                                            child: const Text(

                                              "Delete",

                                              style: TextStyle(
                                                  color: Colors
                                                      .white),

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
