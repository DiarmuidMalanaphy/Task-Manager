import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_management_system/networking/error.dart';
import 'package:task_management_system/networking/task_management_system.dart';
import 'filter_constants.dart';

class AddTaskPage extends StatefulWidget {
  final TaskManagementSystem tms;

  AddTaskPage({Key? key, required this.tms}) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _taskNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _targetUsernameController = TextEditingController();
  Set<int> _selectedFilters = Set<int>();
  bool _isUserVerified = true;
  bool _isAddingToOtherUser = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  List<String> filterNames = FilterConstants.filterNames;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 10).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[100]!, Colors.blue[300]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(24.0),
              children: [
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_animation.value),
                      child: child,
                    );
                  },
                  child: Text(
                    'Create a New Task',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30),
                _buildInputField(_taskNameController, 'Task Name'),
                SizedBox(height: 16),
                _buildInputField(_descriptionController, 'Task Description',
                    maxLines: 3),
                SizedBox(height: 24),
                Text(
                  'Filters:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                _buildFilterChips(),
                SizedBox(height: 24),
                _buildAddToOtherUserCheckbox(),
                if (_isAddingToOtherUser) ...[
                  SizedBox(height: 16),
                  _buildInputField(
                      _targetUsernameController, 'Target Username'),
                ],
                SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    elevation: 5,
                  ),
                  onPressed: _submitForm,
                  child: Text('Add Task',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
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
        ),
        maxLines: maxLines,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
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
        title: Text('Add task to another user'),
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
      var filterOne = _combineFilters();
      var filterTwo = 0;
      var username = await widget.tms.username;
      ReturnError success = await widget.tms.addTask(
        _taskNameController.text,
        _descriptionController.text,
        _targetUsernameController.text,
        username.toString(),
        filterOne,
        filterTwo,
      );

      if (success.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task added successfully')),
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
