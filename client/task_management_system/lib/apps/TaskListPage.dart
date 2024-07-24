import 'package:flutter/material.dart';
import 'package:task_management_system/networking/task_management_system.dart';
import 'package:task_management_system/networking/standards/Task.dart';
import 'package:task_management_system/apps/add_task_page.dart';
import 'package:flutter/material.dart';
import 'package:task_management_system/networking/task_management_system.dart';
import 'package:task_management_system/networking/standards/Task.dart';
import 'package:task_management_system/apps/add_task_page.dart';

class TaskListPage extends StatefulWidget {
  final TaskManagementSystem tms;
  TaskListPage(this.tms);
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  ScrollController _scrollController = ScrollController();
  Set<int> _selectedTasks = {};
  Set<int> _selectedFilters = {};

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  Future<void> _refreshTasks() async {
    try {
      final tasks = await widget.tms.pollTasks(0);
      setState(() {
        _tasks = tasks;
        _applyFilters();
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to load tasks', style: TextStyle(fontSize: 16))),
      );
    }
  }

  void _applyFilters() {
    if (_selectedFilters.isEmpty) {
      _filteredTasks = List.from(_tasks);
    } else {
      _filteredTasks = _tasks
          .where((task) =>
              _selectedFilters.any((filter) => task.getFilter(filter)))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks', style: TextStyle(fontSize: 24)),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshTasks,
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = _filteredTasks[index];
                    return _buildTaskTile(task, index);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 80, // Increased width
        height: 80, // Increased height
        child: FloatingActionButton(
          child: Icon(Icons.add, size: 36),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTaskPage(tms: widget.tms)),
            );
            if (result == true) {
              _refreshTasks();
            }
          },
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40), // Half of the width/height
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 127,
        itemBuilder: (context, index) {
          final filterIndex = index + 1;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label:
                  Text('Filter $filterIndex', style: TextStyle(fontSize: 16)),
              selected: _selectedFilters.contains(filterIndex),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedFilters.add(filterIndex);
                  } else {
                    _selectedFilters.remove(filterIndex);
                  }
                  _applyFilters();
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskTile(Task task, int index) {
    final isSelected = _selectedTasks.contains(task.taskID);
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          _byteArrayToAsciiString(task.taskName),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          _byteArrayToAsciiString(task.taskDescription),
          style: TextStyle(fontSize: 16),
        ),
        tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.delete, size: 28),
              onPressed: () async {
                bool success = await widget.tms.removeTask(task.taskID);
                if (success) {
                  _refreshTasks();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Failed to remove task',
                            style: TextStyle(fontSize: 16))),
                  );
                }
              },
            ),
            Checkbox(
              value: isSelected,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedTasks.add(task.taskID);
                  } else {
                    _selectedTasks.remove(task.taskID);
                  }
                });
              },
            ),
          ],
        ),
        onTap: () {
          _showTaskDetails(task);
        },
      ),
    );
  }

  void _showTaskDetails(Task task) {
    final statusMap = {1: 'Pending', 2: 'Completed'};
    final isOwnTask = _byteArrayToAsciiString(task.setterUsername) ==
        widget.tms.verification.username.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            _byteArrayToAsciiString(task.taskName),
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
                  _buildInfoRow('Assigned by',
                      _byteArrayToAsciiString(task.setterUsername)),
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
                    for (int i = 1; i < 128; i++)
                      if (task.getFilter(i))
                        Chip(
                          label:
                              Text('Filter $i', style: TextStyle(fontSize: 16)),
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
}

String _byteArrayToAsciiString(List<int> bytes) {
  return String.fromCharCodes(bytes.where((byte) => byte >= 32 && byte <= 126))
      .trim();
}
