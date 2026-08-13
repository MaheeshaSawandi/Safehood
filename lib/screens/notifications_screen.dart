import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> notifications = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  // ============================================================
  // FETCH NOTIFICATIONS FROM SUPABASE
  // ============================================================

  Future<void> fetchNotifications() async {
    try {
      final data = await supabase
          .from('notifications')
          .select()
          .order('created_at', ascending: false);

      debugPrint("NOTIFICATIONS FROM SUPABASE: $data");

      if (!mounted) return;

      setState(() {
        notifications = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } catch (e) {
      debugPrint("FETCH NOTIFICATIONS ERROR: $e");

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading notifications: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // MAP 'type' COLUMN -> ICON + COLOR (same icons as before)
  // ============================================================

  IconData iconForType(String type) {
    switch (type) {
      case "police":
        return Icons.local_police;
      case "travel":
        return Icons.location_on;
      case "safe":
        return Icons.check_circle;
      case "feedback":
        return Icons.feedback_outlined;
      default:
        return Icons.warning_amber_rounded;
    }
  }

  Color colorForType(String type) {
    switch (type) {
      case "police":
        return Colors.blue;
      case "travel":
        return Colors.orange;
      case "safe":
        return Colors.green;
      case "feedback":
        return Colors.purple;
      default:
        return Colors.red;
    }
  }

  // ============================================================
  // FORMAT created_at TIMESTAMP -> "x mins ago" STYLE STRING
  // ============================================================

  String timeAgo(String? createdAt) {
    if (createdAt == null) return "";

    final DateTime? time = DateTime.tryParse(createdAt);

    if (time == null) return "";

    final Duration diff = DateTime.now().toUtc().difference(time.toUtc());

    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} mins ago";
    if (diff.inHours < 24) return "${diff.inHours} hour(s) ago";
    if (diff.inDays == 1) return "Yesterday";
    return "${diff.inDays} days ago";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: const Color(0xff2856A6),
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            onPressed: fetchNotifications,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : notifications.isEmpty
              ? const Center(
                  child: Text(
                    "No notifications yet",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView(
        padding: const EdgeInsets.all(16),

        children: notifications.map((notification) {

          final String type =
              notification["type"]?.toString() ?? "alert";

          return notificationCard(

            iconForType(type),

            colorForType(type),

            notification["title"]?.toString() ?? "",

            notification["message"]?.toString() ?? "",

            timeAgo(notification["created_at"]?.toString()),

          );

        }).toList(),
      ),
    );
  }

  Widget notificationCard(
    IconData icon,
    Color color,
    String title,
    String message,
    String time,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
          )
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
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
