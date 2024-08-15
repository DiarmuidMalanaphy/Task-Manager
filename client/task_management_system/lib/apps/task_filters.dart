import 'package:flutter/material.dart';
import 'package:task_management_system/apps/task_list_page.dart';
import 'package:task_management_system/networking/standards/Task.dart';
import 'filter_constants.dart';
import 'dart:typed_data';

enum FilterLogic { AND, OR }

enum FilterInclusion { Include, Exclude }

class TaskFilters extends StatefulWidget {
  final TaskListPageState taskListPage;
  final Function(List<Task_Type>) onFilterApplied;

  TaskFilters({
    Key? key,
    required this.taskListPage,
    required this.onFilterApplied,
  }) : super(key: key);

  @override
  TaskFiltersState createState() => TaskFiltersState();
}

class TaskFiltersState extends State<TaskFilters> {
  Set<int> _selectedFilters = {};
  FilterLogic _filterLogic = FilterLogic.OR;
  FilterInclusion _filterInclusion = FilterInclusion.Include;
  double _priorityThreshold = 0.0;
  String _searchQuery = '';
  bool _caseSensitive = false;

  void applyFilters() {
    if (_selectedFilters.isEmpty) {
      widget.onFilterApplied(widget.taskListPage.getTasks);
    } else {
      List<Task_Type> filteredTasks = _applyFiltersToTasks(
        widget.taskListPage.getTasks,
        _selectedFilters,
        _filterLogic,
        _filterInclusion,
        _searchQuery,
        _caseSensitive,
      );
      widget.onFilterApplied(filteredTasks);
    }
  }

  void _openFilterSettings() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Filter Settings',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Logic: '),
                      DropdownButton<FilterLogic>(
                        value: _filterLogic,
                        onChanged: (FilterLogic? newValue) {
                          if (newValue != null) {
                            setModalState(() {
                              _filterLogic = newValue;
                            });
                            applyFilters();
                          }
                        },
                        items: FilterLogic.values.map((FilterLogic logic) {
                          return DropdownMenuItem<FilterLogic>(
                            value: logic,
                            child: Text(logic.toString().split('.').last),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Inclusion: '),
                      DropdownButton<FilterInclusion>(
                        value: _filterInclusion,
                        onChanged: (FilterInclusion? newValue) {
                          if (newValue != null) {
                            setModalState(() {
                              _filterInclusion = newValue;
                            });
                            applyFilters();
                          }
                        },
                        items: FilterInclusion.values
                            .map((FilterInclusion inclusion) {
                          return DropdownMenuItem<FilterInclusion>(
                            value: inclusion,
                            child: Text(inclusion.toString().split('.').last),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Case Sensitive: '),
                      Switch(
                        value: _caseSensitive,
                        onChanged: (bool value) {
                          setModalState(() {
                            _caseSensitive = value;
                          });
                          applyFilters();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search tasks...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  _searchQuery = value;
                  applyFilters();
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: FilterConstants.filterNames.length,
              itemBuilder: (context, index) {
                final filterName = FilterConstants.filterNames[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: FilterChip(
                    label: Text(filterName, style: TextStyle(fontSize: 16)),
                    selected: _selectedFilters.contains(index),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedFilters.add(index);
                        } else {
                          _selectedFilters.remove(index);
                        }
                        applyFilters();
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Container(
            width: 50,
            child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: _openFilterSettings,
            ),
          ),
        ],
      ),
    );
  }

  static List<Task_Type> _applyFiltersToTasks(
    List<Task_Type> tasks,
    Set<int> selectedFilters,
    FilterLogic logic,
    FilterInclusion inclusion,
    String searchQuery,
    bool caseSensitive,
  ) {
    if (selectedFilters.isEmpty && searchQuery.isEmpty) {
      return List.from(tasks);
    }

    return tasks.where((task) {
      bool matchesFilters = true;
      if (selectedFilters.isNotEmpty) {
        if (logic == FilterLogic.AND) {
          matchesFilters =
              selectedFilters.every((filter) => task.getFilter(filter + 1));
        } else {
          matchesFilters =
              selectedFilters.any((filter) => task.getFilter(filter + 1));
        }

        if (inclusion == FilterInclusion.Exclude) {
          matchesFilters = !matchesFilters;
        }
      }

      bool matchesSearch = searchQuery.isEmpty ||
          (!caseSensitive &&
              (task.taskName
                      .toString()
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()) ||
                  _byteArrayToAsciiString(task.taskDescription)
                      .toLowerCase()
                      .contains(searchQuery.toLowerCase()))) ||
          (caseSensitive &&
              (task.taskName.toString().contains(searchQuery) ||
                  _byteArrayToAsciiString(task.taskDescription)
                      .contains(searchQuery)));
      return matchesFilters && matchesSearch;
    }).toList();
  }
}

String _byteArrayToAsciiString(Uint8List bytes) {
  return String.fromCharCodes(bytes.where((byte) => byte >= 32 && byte <= 126))
      .trim();
}
