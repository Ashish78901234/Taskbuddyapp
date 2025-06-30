import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final String title;
  final String date;
  final Color categoryColor;
  final Color priorityColor;
  final String category;

  const TaskTile({
    super.key,
    required this.title,
    required this.date,
    required this.category,
    required this.categoryColor,
    required this.priorityColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading:  Icon(Icons.check_box_outline_blank),
        title: Text(title),
        subtitle: Text(date),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle, color: priorityColor, size: 12),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                category,
                style: TextStyle(color: categoryColor, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
