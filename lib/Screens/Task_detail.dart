// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final Map<String, dynamic> task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final String title = task['title'] ?? 'No Title';
    final String category = task['category'] ?? 'General';
    final String date = task['date'] ?? 'No Date';
    final String description = task['description'] ?? 'No description';
    final String priority = task['priority'] ?? 'Low';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Task Detail", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () {
              // TODO: Implement delete logic
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.circle, color: Colors.redAccent, size: 12),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                description,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoTile(Icons.event, "Due Date", date),
            const SizedBox(height: 12),
            _buildInfoTile(Icons.note_alt, "Notes", "Add"),
            const SizedBox(height: 12),
            _buildInfoTile(Icons.attach_file, "Attachments", "Add"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      tileColor: Colors.grey.shade100,
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: Text(
        value,
        style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600),
      ),
      onTap: () {
        // TODO: Optional add/edit logic
      },
    );
  }
}
