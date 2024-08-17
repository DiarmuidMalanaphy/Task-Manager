import 'dart:typed_data';
import '../dartproto/Task.pb.dart';
import '../dartproto/Username.pb.dart';
import 'username.dart';
import 'package:fixnum/fixnum.dart';

class Task_Type {
  final Int64 taskID; //Uint64
  final Username_Type taskName;
  final Username_Type targetUsername;
  final Username_Type setterUsername;
  final Uint8List taskDescription;
  int status; //Uint8
  final Int64 filterOne;
  final Int64 filterTwo;

  Task_Type(
    this.taskID,
    this.taskName,
    this.targetUsername,
    this.setterUsername,
    this.status,
    this.taskDescription,
    this.filterOne,
    this.filterTwo,
  ) {
    if (taskName.length != 50) {
      print(taskName.length);
      throw ArgumentError('Task name must be 20 bytes');
    }
    if (targetUsername.length != 50) {
      print(targetUsername.length);
      throw ArgumentError('Target username must be 20 bytes');
    }
    if (setterUsername.length != 50) {
      throw ArgumentError('Setter username must be 20 bytes');
    }
    if (taskDescription.length != 120) {
      throw ArgumentError('Task description must be 120 bytes');
    }
  }

  Set<bool> getAllFilters() {
    Set<bool> filters = {};
    for (int i = 0; i < 128; i++) {
      filters.add(getFilter(i));
    }
    return filters;
  }

  bool getFilter(int filterNumber) {
    if (filterNumber < 0 || filterNumber >= 128) {
      throw ArgumentError('Filter number must be between 0 and 127');
    }
    Int64 filter = (filterNumber < 64) ? filterOne : filterTwo;
    int bitPosition = filterNumber % 64;

    return (filter & (1 << bitPosition)) != 0;
  }

  static Task_Type fromProto(Task protoTask) {
    return Task_Type(
      protoTask.taskID,
      Username_Type.fromProto(protoTask.taskName),
      Username_Type.fromProto(protoTask.targetUsername),
      Username_Type.fromProto(protoTask.setterUsername),
      protoTask.status,
      Uint8List.fromList(protoTask.taskDescription),
      protoTask.filterone,
      protoTask.filtertwo,
    );
  }

  Task get toProto {
    final task = Task()
      ..taskID = taskID
      ..taskName = (Username()..username = taskName.bytes)
      ..targetUsername = (Username()..username = targetUsername.bytes)
      ..setterUsername = (Username()..username = setterUsername.bytes)
      ..status = status
      ..taskDescription = taskDescription
      ..filterone = filterOne
      ..filtertwo = filterTwo;

    return task;
  }

  Uint8List serialize() {
    final task = Task()
      ..taskID = taskID
      ..taskName = (Username()..username = taskName.bytes)
      ..targetUsername = (Username()..username = targetUsername.bytes)
      ..setterUsername = (Username()..username = setterUsername.bytes)
      ..status = status
      ..taskDescription = taskDescription
      ..filterone = filterOne
      ..filtertwo = filterTwo;

    return task.writeToBuffer();
  }
}

List<Task_Type> deserialiseTasks(Uint8List payload) {
  try {
    final taskList = TaskList.fromBuffer(payload);
    return taskList.tasks.map((task) => Task_Type.fromProto(task)).toList();
  } catch (e) {
    print('Error deserializing TaskList: $e');
    return [];
  }
}
