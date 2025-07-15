import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Screens/Add_Task.dart';
import 'package:flutter_application_1/Screens/Task_detail.dart';
import 'package:flutter_application_1/Screens/profile.dart';
import 'package:flutter_application_1/Utils/Theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    fetchUserData();
    super.initState();
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (snapshot.exists) {
        setState(() {
          userData = snapshot.data();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = userData?['name'] ?? 'Guest';
    final photoBase64 = userData?['photo'];
    Uint8List? imageBytes;

    if (photoBase64 != null) {
      imageBytes = base64Decode(photoBase64);
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.grey.shade300,
              backgroundImage:
                  imageBytes != null ? MemoryImage(imageBytes) : null,
              child: imageBytes == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome, $name"),
              ],
            ),
            const Spacer(),
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: IconButton(
                onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(),
      ),
    );
 //profile
                },
                icon: Icon(Icons.person, color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('tasks')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allTasks = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              ...data,
              'id': doc.id,
              'color': Color(data['color'] ?? 0xFF000000),
              'progress': (data['progress'] ?? 0.0).toDouble(),
            };
          }).toList();

          final todo = allTasks.where((t) => t['status'] == 'To-do').toList();
          final inProgress =
              allTasks.where((t) => t['status'] == 'In-Progress').toList();
          final completed =
              allTasks.where((t) => t['status'] == 'Completed').toList();

          return Column(
            children: [
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.black54,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(text: 'To-do (${todo.length})'),
                  Tab(text: 'In-Progress (${inProgress.length})'),
                  Tab(text: 'Completed (${completed.length})'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    buildTaskList(todo, showCheckbox: true),
                    buildTaskList(inProgress, showProgress: true),
                    buildTaskList(completed, showCheckbox: true),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTaskScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildTaskList(List<Map<String, dynamic>> taskList, {
    bool showProgress = false,
    bool showCheckbox = false,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        final task = taskList[index];
        final String category = task['category'];
        final Color categoryColor = task['color'];
        final String title = task['title'];
        final String date = task['date'];
        final double progressValue = task['progress'];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TaskDetailScreen(task: task),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showCheckbox)
                      Checkbox(
                        value: task['status'] == 'Completed',
                        onChanged: (value) async {
                          final uid = FirebaseAuth.instance.currentUser?.uid;
                          if (uid == null) return;

                          String newStatus;
                          if (task['status'] == 'To-do') {
                            newStatus = 'In-Progress';
                          } else if (task['status'] == 'In-Progress') {
                            newStatus = 'Completed';
                          } else {
                            return;
                          }

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(uid)
                              .collection('tasks')
                              .doc(task['id'])
                              .update({'status': newStatus});
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const Icon(Icons.circle, size: 10, color: Colors.red),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      date,
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: categoryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: categoryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                if (showProgress) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progressValue.clamp(0.0, 1.0),
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${(progressValue * 100).toStringAsFixed(0)}% Completed',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}
