import 'package:flutter/material.dart';
import 'package:task_management_system/apps/background_manager.dart';
import 'package:task_management_system/apps/settings_sidebar.dart';
import 'package:task_management_system/apps/splash_page.dart';
import 'package:task_management_system/networking/error.dart';
import 'package:task_management_system/networking/task_management_system.dart';
import 'package:task_management_system/networking/standards/Task.dart';
import 'package:task_management_system/apps/add_task_page.dart';
import 'task_filters.dart';
import 'task_tile.dart';

class TaskListPage extends StatefulWidget {
  final TaskManagementSystem tms;
  final BackgroundManager bm;
  TaskListPage(this.tms, this.bm);
  @override
  TaskListPageState createState() => TaskListPageState();
}

class TaskListPageState extends State<TaskListPage> {
  late List<Task_Type> _tasks = [];
  List<Task_Type> _filteredTasks = [];
  ScrollController _scrollController = ScrollController();
  Set<int> _selectedTasks = {};
  bool _isHovering = false;
  bool _showCompletedTasks = false;
  final GlobalKey<TaskFiltersState> _filtersKey = GlobalKey<TaskFiltersState>();

  late final Widget _filters;

  @override
  void initState() {
    super.initState();
    _filters = TaskFilters(
        key: _filtersKey,
        taskListPage: this,
        onFilterApplied: _handleFilterApplied);

    _showCompletedTasks =
        widget.bm.personalConfigManager.getShowCompletedTasksConfig();
    _refreshTasks();
  }

  void _applyFilters() {
    setState(() {
      final filtersState = _filtersKey.currentState;
      if (filtersState != null) {
        filtersState.applyFilters();
      }
    });
  }

  List<Task_Type> get getTasks {
    return _tasks;
  }

  void setTasks(List<Task_Type> tasks) {
    _tasks = tasks;
  }

  Future<void> _refreshTasks() async {
    try {
      setTasks(await widget.tms.pollTasks(0));
      setState(() {
        _filteredTasks = getTasks;
        _applyFilters();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
      if (!(await widget.tms.removeTask(taskId)).success) {
        success = false;
      }
    }
    _selectedTasks.clear();
    return success;
  }

  Future<bool> _completeTask(int taskID) async {
    ReturnError success = await widget.tms.flipTaskStatus(taskID.toInt());

    // await widget.tms.completeTask(taskId);
    _refreshTasks();
    return success.success;
  }

  Future<void> _completeSelectedTasks() async {
    // Implement the logic to complete multiple selected tasks
    // This is a placeholder for the actual implementation
    print('Completing selected tasks: $_selectedTasks');
    // for (int taskId in _selectedTasks) {
    //  await widget.tms.completeTask(taskId);
    //}
    _selectedTasks.clear();
    _refreshTasks();
  }

  void _deselectAll() {
    setState(() {
      _selectedTasks.clear(); // Correct way to clear a Set
    });
  }

  void _selectAll() {
    setState(() {
      for (var task
          in _filteredTasks.where((task) => task.status != 1).toList()) {
        _selectedTasks.add(task.taskID.toInt());
      }
    });
  }

  void _onSettingsChanged() {
    setState(() {
      _showCompletedTasks =
          widget.bm.personalConfigManager.getShowCompletedTasksConfig();
      // This will trigger a rebuild of the parent widget
    });
  }

  @override
  Widget build(BuildContext context) {
    // Splitting tasks into pending and completed
    List<Task_Type> pendingTasks =
        _filteredTasks.where((task) => task.status != 1).toList();
    List<Task_Type> completedTasks =
        _filteredTasks.where((task) => task.status == 1).toList();

    return Scaffold(
      endDrawer: SettingsSidebar(
        bm: widget.bm,
        tms: widget.tms,
        logout: _logout,
        deleteAccount: _confirmDeleteAccount,
        onSettingsChanged: _onSettingsChanged,
      ),
      body: Stack(
        children: [
          widget.bm.background,
          Container(
            child: SafeArea(
              child: Column(
                children: [
                  _buildAppBar(), // Ensure this method is defined
                  _filters,
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _refreshTasks, // Ensure this method is defined
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          controller: _scrollController,
                          children: [
                            _buildTaskList(pendingTasks, "Pending Tasks",
                                display_empty:
                                    true), // Ensure this method is defined
                            _buildTaskList(completedTasks,
                                "Completed Tasks"), // Ensure this method is defined
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          _buildFloatingActionButton(), // Ensure this method is defined
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tasks',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.check_circle, color: Colors.green),
                onPressed:
                    _selectedTasks.isNotEmpty ? _deselectAll : _selectAll,
              ),
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black87),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Task_Type> tasks, String title,
      {bool display_empty = false}) {
    if (title == "Completed Tasks" && !_showCompletedTasks) {
      return SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ),
          if (tasks.isEmpty && display_empty)
            _buildEmptyTaskIndicator()
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
                    ReturnError err;
                    if (_selectedTasks.isEmpty) {
                      err = await (widget.tms.removeTask(task.taskID.toInt()));
                      success = err.success;
                    } else {
                      success = await _deleteTasks();
                    }

                    _refreshTasks();
                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
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

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                widget.tms.deleteAccount();
                _logout();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyTaskIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 50,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 10),
            Text(
              "No tasks yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 5),
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
        duration: const Duration(milliseconds: 200),
        width: _isHovering ? 90 : 60,
        height: _isHovering ? 90 : 60,
        child: FloatingActionButton(
          child: Icon(Icons.add, size: _isHovering ? 40 : 30),
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTaskPage(
                        tms: widget.tms,
                        bm: widget.bm,
                      )),
            );
            if (result == true) {
              _refreshTasks();
            }
          },
          backgroundColor: Colors.blue[300],
          elevation: 8,
        ),
      ),
    );
  }

  void _logout() {
    widget.tms.clearVerification();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => SplashPage()),
      (Route<dynamic> route) => false,
    );
  }
}
