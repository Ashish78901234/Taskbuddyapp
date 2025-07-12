import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Screens/Add_Task.dart';
import 'package:flutter_application_1/Screens/Task_detail.dart';
import 'package:flutter_application_1/Utils/Theme.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();

    // Delay fetchUserData after first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchUserData();
    });
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (snapshot.exists && mounted) {
        setState(() {
          userData = snapshot.data();
        });
      }
    }
  }

  Color getPriorityDotColor(String category) {
    switch (category) {
      case 'Work':
      case 'Education':
        return Colors.red;
      case 'Home':
        return Colors.orange;
      case 'Personal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final name = userData?['name'] ?? 'Guest';
    final photoBase64 = userData?['photo'];
    Uint8List? imageBytes;

    if (photoBase64 != null) {
      imageBytes = base64Decode(photoBase64);
    }

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
              backgroundImage: imageBytes != null ? MemoryImage(imageBytes) : null,
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
                onPressed: () {},
                icon: Icon(Icons.person, color: AppColors.primary),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .collection('tasks')
                .snapshots(),
            builder: (context, snapshot) {
              final allTasks = snapshot.data?.docs ?? [];
              int count(String status) =>
                  allTasks.where((doc) => (doc.data() as Map)['status'] == status).length;

              return TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.black54,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(text: "To-do (${count('To-do')})"),
                  Tab(text: "In-Progress (${count('In-Progress')})"),
                  Tab(text: "Completed (${count('Completed')})"),
                ],
              );
            },
          ),
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
            };
          }).toList();

          final tabs = ['To-do', 'In-Progress', 'Completed'];
          return TabBarView(
            controller: _tabController,
            children: tabs.map((status) {
              final filtered = allTasks.where((task) => task['status'] == status).toList();
              return buildTaskList(filtered);
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          );
        },
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildTaskList(List<Map<String, dynamic>> taskList) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        final task = taskList[index];
        final String category = task['category'];
        final Color categoryColor = task['color'];
        final String title = task['title'];
        final String date = task['date'];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task)),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: task['status'] == 'Completed',
                        onChanged: task['status'] == 'Completed'
                            ? null
                            : (value) async {
                                final uid = FirebaseAuth.instance.currentUser?.uid;
                                if (uid == null) return;
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uid)
                                    .collection('tasks')
                                    .doc(task['id'])
                                    .update({'status': 'Completed'});
                              },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(date,
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: getPriorityDotColor(category),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                          color: categoryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
