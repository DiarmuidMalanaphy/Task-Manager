import 'package:flutter/material.dart';
import 'package:task_management_system/networking/standards/Task.dart';
import 'package:task_management_system/networking/task_management_system.dart';
import 'task_details_dialog.dart';
import 'dart:typed_data';

class TaskTile extends StatelessWidget {
  final Task_Type task;
  final bool isSelected;
  final Function(bool?) onCheckboxChanged;
  final VoidCallback onDelete;
  final Function(int) onComplete;
  final TaskManagementSystem tms;

  TaskTile({
    required this.task,
    required this.isSelected,
    required this.onCheckboxChanged,
    required this.onDelete,
    required this.onComplete,
    required this.tms,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = task.status == 1;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          task.taskName.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          _byteArrayToAsciiString(task.taskDescription),
          style: TextStyle(fontSize: 16),
        ),
        tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: isSelected,
              onChanged: onCheckboxChanged,
            ),
            IconButton(
              icon: Icon(Icons.check_circle_outline, size: 28),
              onPressed: () {
                onComplete(task.taskID.toInt());
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 28),
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: () {
          showTaskDetails(context, task, tms);
        },
      ),
    );
  }
}

String _byteArrayToAsciiString(Uint8List bytes) {
  return String.fromCharCodes(bytes.where((byte) => byte >= 32 && byte <= 126))
      .trim();
}
