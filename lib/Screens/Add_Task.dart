import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Utils/Date_Format.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedCategory = '';
  String _selectedPriority = 'Low';

  final List<String> categories = [
    'Work', 'Education', 'Shopping', 'Personal', 'Home', 'Custom'
  ];

  void _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.isEmpty || _selectedCategory.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not logged in")),
      );
      return;
    }

    final taskData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'category': _selectedCategory,
      'date': DateFormatter.format(_selectedDate!),
      'priority': _selectedPriority,
      'status': 'To-do',
      'color': _getCategoryColor(_selectedCategory).value,
      'createdAt': Timestamp.now(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tasks')
          .add(taskData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task saved successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Work':
        return Colors.blue;
      case 'Education':
        return Colors.purple;
      case 'Shopping':
        return Colors.orange;
      case 'Personal':
        return Colors.green;
      case 'Home':
        return Colors.teal;
      case 'Custom':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Add new task", style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Title"),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Enter task title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Description"),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Enter Description here......",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Select Category"),
            Wrap(
              spacing: 8.0,
              children: categories.map((cat) {
                final bool isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: Colors.purple,
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black),
                  onSelected: (_) {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text("Deadline"),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'Select a date'
                          : DateFormatter.format(_selectedDate!),
                    ),
                    const Icon(Icons.calendar_today, size: 18)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Set Priority"),
            Row(
              children: ['Low', 'Medium', 'High'].map((priority) {
                return Expanded(
                  child: RadioListTile(
                    title: Text(priority),
                    value: priority,
                    groupValue: _selectedPriority,
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value.toString();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Save Task!"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
