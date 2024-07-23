import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_management_system/networking/standards/base.dart';
import 'package:task_management_system/networking/task_management_system.dart';
import 'package:task_management_system/networking/standards/Task.dart';
import 'package:task_management_system/networking/standards/utility.dart';
import 'dart:async';

enum TaskFilter {
  Filter1,
  Filter2,
  Filter3,
  Filter4,
  Filter5,
  Filter6,
  Filter7,
  Filter8
}

class AddTaskPage extends StatefulWidget {
  final TaskManagementSystem tms;

  AddTaskPage({Key? key, required this.tms}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetUsernameController = TextEditingController();
  Set<TaskFilter> _selectedFilters = Set<TaskFilter>();
  bool _isUserVerified = true;
  bool _isAddingToOtherUser = false;

  @override
  void initState() {
    super.initState();
    _targetUsernameController.text =
        widget.tms.verification.username.toString();
    print(_targetUsernameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Task')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _taskNameController,
              decoration: InputDecoration(labelText: 'Task Name'),
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
                FilteringTextInputFormatter.allow(RegExp(r'[\x00-\x7F]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a task name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Task Description'),
              maxLines: null, // This allows the field to grow
              minLines: 1, // This sets the initial height
              keyboardType: TextInputType.multiline,
              inputFormatters: [
                LengthLimitingTextInputFormatter(120),
                FilteringTextInputFormatter.allow(RegExp(r'[\x00-\x7F]')),
              ],
            ),
            SizedBox(height: 16),
            Text('Filters:'),
            DropdownButton<TaskFilter>(
              isExpanded: true,
              hint: Text('Select filters'),
              items: TaskFilter.values.map((TaskFilter filter) {
                return DropdownMenuItem<TaskFilter>(
                  value: filter,
                  child: Text(filter.toString().split('.').last),
                );
              }).toList(),
              onChanged: (TaskFilter? newValue) {
                if (newValue != null) {
                  setState(() {
                    if (_selectedFilters.contains(newValue)) {
                      _selectedFilters.remove(newValue);
                    } else {
                      _selectedFilters.add(newValue);
                    }
                  });
                }
              },
            ),
            Wrap(
              spacing: 8.0,
              children: _selectedFilters.map((filter) {
                return Chip(
                  label: Text(filter.toString().split('.').last),
                  onDeleted: () {
                    setState(() {
                      _selectedFilters.remove(filter);
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isAddingToOtherUser,
                  onChanged: (bool? value) {
                    setState(() {
                      _isAddingToOtherUser = value ?? false;
                      if (!_isAddingToOtherUser) {
                        _targetUsernameController.text =
                            widget.tms.verification.username.toString();
                        _isUserVerified = true;
                      } else {
                        _targetUsernameController.clear();
                        _isUserVerified = false;
                      }
                    });
                  },
                ),
                Text('Add task to another user'),
              ],
            ),
            if (_isAddingToOtherUser)
              TextFormField(
                controller: _targetUsernameController,
                decoration: InputDecoration(labelText: 'Target Username'),
                inputFormatters: [
                  LengthLimitingTextInputFormatter(30),
                  FilteringTextInputFormatter.allow(RegExp(r'[\x00-\x7F]')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a target username';
                  }
                  if (!_isUserVerified) {
                    return 'Invalid user';
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value != widget.tms.verification.username.toString()) {
                    _isUserVerified = false;
                    // Debounce the verification call
                    _debounceVerifyUser();
                  } else {
                    setState(() {
                      _isUserVerified = true;
                    });
                  }
                },
              ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_isAddingToOtherUser && !_isUserVerified) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("The selected user doesn't exist")),
                  );
                } else {
                  _submitForm();
                }
              },
              child: Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  Timer? _debounceTimer;

  void _debounceVerifyUser() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), _verifyUser);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _verifyUser() async {
    if (_isAddingToOtherUser &&
        _targetUsernameController.text !=
            widget.tms.verification.username.toString()) {
      bool userExists =
          await widget.tms.verify_user_exists(_targetUsernameController.text);
      setState(() {
        _isUserVerified = userExists;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var filterOne = _combineFilters();
      var filterTwo = 0;

      bool success = await widget.tms.addTask(
        _taskNameController.text,
        _descriptionController.text,
        _targetUsernameController.text,
        filterOne,
        filterTwo,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task added successfully')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add task')),
        );
      }
    }
  }

  int _combineFilters() {
    int result = 0;
    for (TaskFilter filter in _selectedFilters) {
      result |= (1 << filter.index);
    }
    return result;
  }
}
