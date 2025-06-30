import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/Add_Task.dart';
import 'package:flutter_application_1/Utils/TaskTile.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TaskHomePage(),
  ));
}

class TaskHomePage extends StatelessWidget {
  const TaskHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFEDE7F6),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(
                    ''), // Replace with actual user image
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Welcome, Ahsan Khan",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Prioritize. Plan. Achieve.",
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ],
          ),
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.person_outline, color: Colors.deepPurple),
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.deepPurple,
            tabs: [
              Tab(text: 'To-do'),
              Tab(text: 'In-Progress'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TaskList(tabType: 'todo'),
            TaskList(tabType: 'inprogress'),
            TaskList(tabType: 'completed'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
             Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );
          },
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final String tabType;
  const TaskList({super.key, required this.tabType});

  @override
  Widget build(BuildContext context) {
    List<TaskTile> allTasks = const [
      TaskTile(
        title: 'UI/UX Design Task',
        date: '1 Feb, 2025',
        category: 'Work',
        categoryColor: Colors.blue,
        priorityColor: Colors.red,
      ),
      TaskTile(
        title: 'Submit project report',
        date: '1 Feb, 2025',
        category: 'Education',
        categoryColor: Colors.purple,
        priorityColor: Colors.red,
      ),
      TaskTile(
        title: 'Read 10 pages of a book',
        date: '1 Feb, 2025',
        category: 'Personal',
        categoryColor: Colors.orange,
        priorityColor: Colors.green,
      ),
      TaskTile(
        title: 'Buy groceries for the week',
        date: '1 Feb, 2025',
        category: 'Home',
        categoryColor: Colors.green,
        priorityColor: Colors.orange,
      ),
    ];

    // You can later filter based on `tabType` using a real data model
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: allTasks,
    );
  }
}
