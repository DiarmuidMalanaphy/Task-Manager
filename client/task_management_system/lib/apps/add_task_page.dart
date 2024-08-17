import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_management_system/apps/background_manager.dart';
import 'package:task_management_system/networking/error.dart';
import 'package:task_management_system/networking/task_management_system.dart';
import 'filter_constants.dart';

class AddTaskPage extends StatefulWidget {
  final TaskManagementSystem tms;
  final BackgroundManager bm;

  AddTaskPage({Key? key, required this.tms, required this.bm})
      : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetUsernameController = TextEditingController();
  Set<int> _selectedFilters = Set<int>();
  bool _isAddingToOtherUser = false;
  bool _isUserVerified = false;

  List<String> filterNames = FilterConstants.filterNames;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Task'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background animation
          widget.bm.background, // Ensure this widget is defined

          //// Foreground content
          Container(
            //  ),
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(24.0),
                  children: [
                    const SizedBox(height: 30),
                    _buildInputField(_taskNameController, 'Task Name',
                        maxLength: 60),
                    const SizedBox(height: 16),
                    _buildInputField(_descriptionController, 'Task Description',
                        maxLines: 3, maxLength: 120),
                    const SizedBox(height: 24),
                    const Text(
                      'Filters:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildFilterChips(),
                    const SizedBox(height: 24),
                    _buildAddToOtherUserCheckbox(),
                    if (_isAddingToOtherUser) ...[
                      const SizedBox(height: 16),
                      _buildInputField(
                          _targetUsernameController, 'Target Username',
                          maxLength: 60),
                    ],
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.purple[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        elevation: 5,
                      ),
                      onPressed: _submitForm,
                      child: const Text(
                        'Add Task',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label,
      {int maxLines = 1, int? maxLength}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          counterText: '${controller.text.length}/${maxLength ?? 'unlimited'}',
        ),
        maxLines: maxLines,
        maxLength: maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (maxLength != null && value.length > maxLength) {
            return '$label must be at most $maxLength characters';
          }
          return null;
        },
        onChanged: (value) {
          // This will rebuild the widget to update the character count
          setState(() {});
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: List.generate(filterNames.length, (index) {
        return FilterChip(
          label: Text(filterNames[index]),
          selected: _selectedFilters.contains(index),
          onSelected: (bool selected) {
            setState(() {
              if (selected) {
                _selectedFilters.add(index);
              } else {
                _selectedFilters.remove(index);
              }
            });
          },
          backgroundColor: Colors.white.withOpacity(0.7),
          selectedColor: Colors.blue[200],
          checkmarkColor: Colors.blue[800],
          labelStyle: TextStyle(color: Colors.blue[800]),
        );
      }),
    );
  }

  Widget _buildAddToOtherUserCheckbox() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: CheckboxListTile(
        title: const Text('Add task to another user'),
        value: _isAddingToOtherUser,
        onChanged: (bool? value) {
          setState(() {
            _isAddingToOtherUser = value ?? false;
            if (!_isAddingToOtherUser && widget.tms.username != null) {
              _targetUsernameController.text = widget.tms.username.toString();
              _isUserVerified = true;
            } else {
              _targetUsernameController.clear();
              _isUserVerified = false;
            }
          });
        },
      ),
    );
  }

  void _updateUserVerification(String value) {
    if (widget.tms.username != null) {
      if (value != widget.tms.username.toString()) {
        setState(() {
          _isUserVerified = false;
        });
        _debounceVerifyUser();
      } else {
        setState(() {
          _isUserVerified = true;
        });
      }
    } else {
      // Handle the case where username is null
      setState(() {
        _isUserVerified = false;
      });
    }
  }

  Timer? _debounceTimer;

  void _debounceVerifyUser() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), _verifyUser);
  }

  void _verifyUser() async {
    if (_isAddingToOtherUser &&
        widget.tms.username != null &&
        _targetUsernameController.text != widget.tms.username.toString()) {
      ReturnError err;
      err = await widget.tms.verifyUserExists(_targetUsernameController.text);
      setState(() {
        _isUserVerified = err.success;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_taskNameController.text.length > 60) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Task name must be at most 60 characters")),
        );
        return;
      }
      if (_taskNameController.text.length > 60) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Target username must be at most 60 characters")),
        );
        return;
      }

      if (_descriptionController.text.length > 120) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Task description must be at most 120 characters")),
        );
        return;
      }

      var filterOne = _combineFilters();
      var filterTwo = 0;
      if ((filterTwo + filterOne) == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("There must be atleast one filter applied")),
        );
        return;
      }

      var username = await widget.tms.username;

      String targetUsername = (_targetUsernameController.text == "")
          ? username.toString()
          : _targetUsernameController.text;
      ReturnError success = await widget.tms.addTask(
        _taskNameController.text,
        _descriptionController.text,
        username.toString(),
        targetUsername,
        filterOne,
        filterTwo,
      );

      if (success.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task added successfully')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(success.message)),
        );
      }
    }
  }

  int _combineFilters() {
    int result = 0;
    for (int filterIndex in _selectedFilters) {
      result |= (2 << filterIndex);
    }
    return result;
  }
}
