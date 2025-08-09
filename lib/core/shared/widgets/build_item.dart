import 'package:flutter/material.dart';
import 'build_task_item.dart';

class BuildItem extends StatelessWidget {
  final List<dynamic> tasks;

  const BuildItem({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isNotEmpty) {
      return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) => BuildTaskItem(model: tasks[index]),
        separatorBuilder:
            (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Divider(height: 1.0, color: Colors.grey),
        ),
        itemCount: tasks.length,
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No Tasks Yet',
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[300],
              ),
            ),
            Icon(Icons.menu, color: Colors.grey[300], size: 100.0),
          ],
        ),
      );
    }
  }
}