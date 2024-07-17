import 'dart:typed_data';
import 'base.dart';
import 'utility.dart';

class Task {
  static const int SIZE = 8 + 20 + 20 + 20 + 1 + 120 + 8 + 8; // 205 bytes total

  final int taskID;
  final Username taskName;
  final Username targetUsername;
  final Username setterUsername;
  final int status;
  final Uint8List taskDescription;
  final int filterOne;
  final int filterTwo;

  Task(this.taskID, this.taskName, this.targetUsername, this.setterUsername,
      this.status, this.taskDescription, this.filterOne, this.filterTwo) {
    if (taskDescription.length != 120) {
      throw ArgumentError('Task description must be 120 bytes');
    }
  }

  Uint8List serialize() {
    var buffer = ByteData(SIZE);
    var offset = 0;

    buffer.setUint64(offset, taskID, Endian.little);
    offset += 8;

    buffer.buffer.asUint8List(offset, 20).setAll(0, taskName.bytes);
    offset += 20;

    buffer.buffer.asUint8List(offset, 20).setAll(0, targetUsername.bytes);
    offset += 20;

    buffer.buffer.asUint8List(offset, 20).setAll(0, setterUsername.bytes);
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

    var buffer = ByteData.view(data.buffer);
    var offset = 0;

    var taskID = buffer.getUint64(offset, Endian.little);
    offset += 8;

    var taskName = Username.fromBytes(data.sublist(offset, offset + 20));
    offset += 20;

    var targetUsername = Username.fromBytes(data.sublist(offset, offset + 20));
    offset += 20;

    var setterUsername = Username.fromBytes(data.sublist(offset, offset + 20));
    offset += 20;

    var status = buffer.getUint8(offset);
    offset += 1;

    var taskDescription = data.sublist(offset, offset + 120);
    offset += 120;

    var filterOne = buffer.getUint64(offset, Endian.little);
    offset += 8;

    var filterTwo = buffer.getUint64(offset, Endian.little);

    return Task(taskID, taskName, targetUsername, setterUsername, status,
        taskDescription, filterOne, filterTwo);
  }
}
