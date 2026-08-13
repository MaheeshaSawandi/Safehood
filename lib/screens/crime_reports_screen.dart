import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CrimeReportsScreen extends StatefulWidget {
  const CrimeReportsScreen({super.key});

  @override
  State<CrimeReportsScreen> createState() => _CrimeReportsScreenState();
}

class _CrimeReportsScreenState extends State<CrimeReportsScreen> {

  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> reports = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReports();
  }

  // ============================================================
  // FETCH CRIME REPORTS FROM SUPABASE
  // ============================================================

  Future<void> fetchReports() async {
    try {
      final data = await supabase
          .from('crime_reports')
          .select()
          .order('created_at', ascending: false);

      debugPrint("CRIME REPORTS FROM SUPABASE: $data");

      if (!mounted) return;

      setState(() {
        reports = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("FETCH CRIME REPORTS ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading reports: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // DELETE CRIME REPORT FROM SUPABASE
  // ============================================================

  Future<void> deleteReport(int index) async {
    final report = reports[index];

    try {
      await supabase
          .from('crime_reports')
          .delete()
          .eq('id', report['id']);

      debugPrint("CRIME REPORT DELETED: ${report['id']}");

      if (!mounted) return;

      setState(() {
        reports.removeAt(index);
      });
    } catch (e) {
      debugPrint("DELETE CRIME REPORT ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting report: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Color statusColor(String status) {

    switch (status) {

      case "Resolved":
        return Colors.green;

      case "Investigating":
        return Colors.orange;

      default:
        return Colors.red;

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
          "Crime Reports",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            onPressed: fetchReports,
            icon: const Icon(Icons.refresh),
          ),
        ],

      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            TextField(

              decoration: InputDecoration(

                hintText: "Search reports...",

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
                  : reports.isEmpty
                      ? const Center(
                          child: Text(
                            "No crime reports found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(

                itemCount: reports.length,

                itemBuilder: (context, index) {

                  final report = reports[index];

                  return Card(

                    elevation: 3,

                    margin: const EdgeInsets.only(bottom: 15),

                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(15),

                    ),

                    child: Padding(

                      padding: const EdgeInsets.all(15),

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Row(

                            children: [

                              CircleAvatar(

                                radius: 25,

                                backgroundColor: Colors.red.shade100,

                                child: const Icon(

                                  Icons.report,

                                  color: Colors.red,

                                ),

                              ),

                              const SizedBox(width: 15),

                              Expanded(

                                child: Text(

                                  report["crime"]!,

                                  style: const TextStyle(

                                    fontSize: 17,

                                    fontWeight: FontWeight.bold,

                                  ),

                                ),

                              ),

                              Container(

                                padding: const EdgeInsets.symmetric(

                                  horizontal: 10,

                                  vertical: 5,

                                ),

                                decoration: BoxDecoration(

                                  color: statusColor(
                                    report["status"]!,
                                  ).withValues(alpha: 0.15),

                                  borderRadius:
                                      BorderRadius.circular(20),

                                ),

                                child: Text(

                                  report["status"]!,

                                  style: TextStyle(

                                    color: statusColor(
                                      report["status"]!,
                                    ),

                                    fontWeight: FontWeight.bold,

                                  ),

                                ),

                              ),

                            ],

                          ),

                          const SizedBox(height: 15),

                          Row(

                            children: [

                              const Icon(
                                Icons.location_on,
                                color: Colors.blue,
                                size: 18,
                              ),

                              const SizedBox(width: 5),

                              Text(report["location"]!),

                            ],

                          ),

                          const SizedBox(height: 8),

                          Row(

                            children: [

                              const Icon(
                                Icons.calendar_today,
                                color: Colors.blue,
                                size: 18,
                              ),

                              const SizedBox(width: 5),

                              Text(report["incident_date"]!.toString()),

                            ],

                          ),

                          const Divider(height: 25),

                          Row(

                            mainAxisAlignment:
                                MainAxisAlignment.end,

                            children: [

                              ElevatedButton.icon(

                                style: ElevatedButton.styleFrom(

                                  backgroundColor: Colors.blue,

                                ),

                                onPressed: () {

                                  showDialog(

                                    context: context,

                                    builder: (_) => AlertDialog(

                                      title: const Text(
                                        "Crime Report",
                                      ),

                                      content: Text(

                                        "Crime : ${report["crime"]}\n\n"

                                        "Location : ${report["location"]}\n\n"

                                        "Date : ${report["incident_date"]}\n\n"

                                        "Status : ${report["status"]}",

                                      ),

                                      actions: [

                                        TextButton(

                                          onPressed: () {

                                            Navigator.pop(context);

                                          },

                                          child: const Text("Close"),

                                        )

                                      ],

                                    ),

                                  );

                                },

                                icon: const Icon(

                                  Icons.visibility,

                                  color: Colors.white,

                                ),

                                label: const Text(

                                  "View",

                                  style: TextStyle(
                                    color: Colors.white,
                                  ),

                                ),

                              ),

                              const SizedBox(width: 10),

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
                                          "Delete Report",
                                        ),

                                        content: Text(

                                          "Delete ${report["crime"]} report?",

                                        ),

                                        actions: [

                                          TextButton(

                                            onPressed: () {

                                              Navigator.pop(context);

                                            },

                                            child: const Text(
                                              "Cancel",
                                            ),

                                          ),

                                          ElevatedButton(

                                            style:
                                                ElevatedButton.styleFrom(

                                              backgroundColor: Colors.red,

                                            ),

                                            onPressed: () async {

                                              Navigator.pop(context);

                                              await deleteReport(index);

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