import 'dart:typed_data';
import 'base.dart';
import 'utility.dart';
import 'datatypes.dart';

class Task {
  static const int SIZE = 8 + 20 + 20 + 20 + 1 + 120 + 8 + 8; // 205 bytes total

  final int taskID; //Uint64
  final Uint8List taskName;
  final Uint8List targetUsername;
  final Uint8List setterUsername;
  final int status; //Uint8
  final Uint8List taskDescription;
  final int filterOne;
  final int filterTwo;

  Task(
    this.taskID,
    this.taskName,
    this.targetUsername,
    this.setterUsername,
    this.status,
    this.taskDescription,
    this.filterOne,
    this.filterTwo,
  ) {
    if (taskName.length != 20) {
      throw ArgumentError('Task name must be 20 bytes');
    }
    if (targetUsername.length != 20) {
      throw ArgumentError('Target username must be 20 bytes');
    }
    if (setterUsername.length != 20) {
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

    int filter = (filterNumber < 64) ? filterOne : filterTwo;
    int bitPosition = filterNumber % 64;

    return (filter & (1 << bitPosition)) != 0;
  }

  Uint8List serialize() {
    final buffer = ByteData(SIZE);
    var offset = 0;

    buffer.setUint64(offset, taskID, Endian.little);
    offset += 8;

    buffer.buffer.asUint8List(offset, 20).setAll(0, taskName);
    offset += 20;

    buffer.buffer.asUint8List(offset, 20).setAll(0, targetUsername);
    offset += 20;

    buffer.buffer.asUint8List(offset, 20).setAll(0, setterUsername);
    offset += 20;

    buffer.setUint8(offset, status);
    offset += 1;

    buffer.buffer.asUint8List(offset, 120).setAll(0, taskDescription);
    offset += 120;

    buffer.setUint64(offset, filterOne, Endian.little);
    offset += 8;

    buffer.setUint64(offset, filterTwo, Endian.little);

    return buffer.buffer.asUint8List();
  }

  static Task deserialize(Uint8List data) {
    if (data.length != SIZE) {
      throw ArgumentError('Invalid data length for Task deserialization');
    }

    final buffer = ByteData.view(data.buffer);
    var offset = 0;

    final taskID = buffer.getUint64(offset, Endian.little);
    offset += 8;

    final taskName = data.sublist(offset, offset + 20);
    offset += 20;

    final targetUsername = data.sublist(offset, offset + 20);
    offset += 20;

    final setterUsername = data.sublist(offset, offset + 20);
    offset += 20;

    final status = buffer.getUint8(offset);
    offset += 1;

    final taskDescription = data.sublist(offset, offset + 120);
    offset += 120;

    final filterOne = buffer.getUint64(offset, Endian.little);
    offset += 8;

    final filterTwo = buffer.getUint64(offset, Endian.little);

    return Task(
      taskID,
      taskName,
      targetUsername,
      setterUsername,
      status,
      taskDescription,
      filterOne,
      filterTwo,
    );
  }
}

List<Task> deserialiseTaskList(Uint8List payload) {
  if (payload.length % Task.SIZE != 0) {
    throw ArgumentError('Invalid payload length for Task list deserialization');
  }

  List<Task> taskList = [];
  for (int i = 0; i < payload.length; i += Task.SIZE) {
    Uint8List taskData = payload.sublist(i, i + Task.SIZE);
    Task task = Task.deserialize(taskData);
    taskList.add(task);
  }

  return taskList;
}
