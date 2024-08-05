import 'package:flutter/material.dart';
import 'package:task_management_system/networking/standards/Task.dart';
import 'package:task_management_system/networking/task_management_system.dart';
import 'filter_constants.dart';
import 'dart:typed_data';

void showTaskDetails(
    BuildContext context, Task_Type task, TaskManagementSystem tms) {
  final statusMap = {0: 'Pending', 1: 'Completed'};
  final isOwnTask =
      task.setterUsername.toString() == tms.verification.username.toString();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          task.taskName.toString(),
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _byteArrayToAsciiString(task.taskDescription),
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 24),
              _buildInfoRow('Status', statusMap[task.status] ?? 'Unknown'),
              if (!isOwnTask)
                _buildInfoRow('Assigned by', task.setterUsername.toString()),
              SizedBox(height: 24),
              Text(
                'Filters:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  for (int i = 0; i < FilterConstants.filterNames.length; i++)
                    if (task.getFilter(i + 1))
                      Chip(
                        label: Text(FilterConstants.filterNames[i],
                            style: TextStyle(fontSize: 16)),
                        backgroundColor: Colors.blue[100],
                      ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Close', style: TextStyle(fontSize: 18)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Widget _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Expanded(
          child: Text(value, style: TextStyle(fontSize: 18)),
        ),
      ],
    ),
  );
}

String _byteArrayToAsciiString(Uint8List bytes) {
  return String.fromCharCodes(bytes.where((byte) => byte >= 32 && byte <= 126))
      .trim();
}
