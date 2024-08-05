import 'package:flutter/material.dart';
import 'package:task_management_system/apps/splash_page.dart';
import 'package:task_management_system/networking/task_management_system.dart';
import 'package:task_management_system/networking/standards/Task.dart';
import 'package:task_management_system/apps/add_task_page.dart';
import '../main.dart';
import 'task_filters.dart';
import 'task_tile.dart';

class TaskListPage extends StatefulWidget {
  final TaskManagementSystem tms;
  TaskListPage(this.tms);
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task_Type> _tasks = [];
  List<Task_Type> _filteredTasks = [];
  ScrollController _scrollController = ScrollController();
  Set<int> _selectedTasks = {};
  bool _isHovering = false;
  bool _showCompletedTasks = true;

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
        _filteredTasks = tasks;
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

  void _handleFilterApplied(List<Task_Type> filteredTasks) {
    setState(() {
      _filteredTasks = filteredTasks;
    });
  }

  Future<bool> _deleteTasks() async {
    bool success = true;
    for (int taskId in _selectedTasks) {
      if (!await widget.tms.removeTask(taskId)) {
        success = false;
      }
    }
    _selectedTasks.clear();
    return success;
  }

  Future<bool> _completeTask(int taskID) async {
    bool success = await widget.tms.flipTaskStatus(taskID.toInt());

    // await widget.tms.completeTask(taskId);
    _refreshTasks();
    return success;
  }

  Future<void> _completeSelectedTasks() async {
    // Implement the logic to complete multiple selected tasks
    // This is a placeholder for the actual implementation
    print('Completing selected tasks: $_selectedTasks');
    // for (int taskId in _selectedTasks) {
    //   await widget.tms.completeTask(taskId);
    // }
    _selectedTasks.clear();
    _refreshTasks();
  }

  @override
  Widget build(BuildContext context) {
    List<Task_Type> pendingTasks =
        _filteredTasks.where((task) => task.status != 1).toList();
    List<Task_Type> completedTasks =
        _filteredTasks.where((task) => task.status == 1).toList();

    return Scaffold(
      endDrawer: _buildSettingsSidebar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.blue[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: Text('Tasks', style: TextStyle(fontSize: 24)),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: Icon(Icons.check_circle),
                    onPressed: _selectedTasks.isNotEmpty
                        ? _completeSelectedTasks
                        : null,
                  ),
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openEndDrawer(),
                    ),
                  ),
                ],
              ),
              TaskFilters(tasks: _tasks, onFilterApplied: _handleFilterApplied),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshTasks,
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      controller: _scrollController,
                      children: [
                        _buildTaskList(pendingTasks, "Pending Tasks",
                            display_empty: true),
                        _buildTaskList(completedTasks, "Completed Tasks"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildTaskList(List<Task_Type> tasks, String title,
      {bool display_empty = false}) {
    if (title == "Completed Tasks" && !_showCompletedTasks) {
      return SizedBox.shrink();
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          if (tasks.isEmpty && display_empty)
            _buildEmptyTaskIndicator()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskTile(
                  task: task,
                  isSelected: _selectedTasks.contains(task.taskID.toInt()),
                  onCheckboxChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedTasks.add(task.taskID.toInt());
                      } else {
                        _selectedTasks.remove(task.taskID.toInt());
                      }
                    });
                  },
                  onDelete: () async {
                    bool success = false;
                    if (_selectedTasks.length < 1) {
                      success =
                          await widget.tms.removeTask(task.taskID.toInt());
                    } else {
                      success = await _deleteTasks();
                    }

                    _refreshTasks();
                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Failed to remove task',
                                style: TextStyle(fontSize: 16))),
                      );
                    }
                  },
                  onComplete: (int taskId) async {
                    await _completeTask(task.taskID.toInt());
                    _refreshTasks();
                  },
                  tms: widget.tms,
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsSidebar() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[300]!, Colors.blue[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Customize your app experience',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: Text('Show Completed Tasks'),
            subtitle: Text('Display or hide completed tasks in the list'),
            value: _showCompletedTasks,
            onChanged: (bool value) {
              setState(() {
                _showCompletedTasks = value;
              });
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              _logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTaskIndicator() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 50,
              color: Colors.grey[600],
            ),
            SizedBox(height: 10),
            Text(
              "No tasks yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 5),
            Text(
              "Tap the + button to create a new task",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: _isHovering ? 90 : 60,
        height: _isHovering ? 90 : 60,
        child: FloatingActionButton(
          child: Icon(Icons.add, size: _isHovering ? 40 : 30),
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
          backgroundColor: Colors.purple[700],
          elevation: 8,
        ),
      ),
    );
  }

  void _logout() {
    widget.tms.resetVerification();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SplashPage()),
      (Route<dynamic> route) => false,
    );
  }
}
