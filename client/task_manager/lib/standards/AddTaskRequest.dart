import 'base.dart';
import 'dart:typed_data';

class AddTaskRequest {
  final Verification verification;
  final Task newTask;

  AddTaskRequest(this.verification, this.newTask);
}

Uint8List serializeAddTaskRequest(AddTaskRequest request) {
  var buffer = ByteData(52 + Task.SIZE); // 52 bytes verification + Task size
  buffer.buffer.asUint8List(0, 20).setAll(0, request.verification.username.bytes);
  buffer.buffer.asUint8List(20, 32).setAll(0, request.verification.hash);
  buffer.buffer.asUint8List(52, Task.SIZE).setAll(0, request.newTask.serialize());
  return buffer.buffer.asUint8List();
}

AddTaskRequest? deserializeAddTaskRequest(Uint8List? payload) {
  if (payload != null && payload.length == 52 + Task.SIZE) {
    var username = Username.fromBytes(payload.sublist(0, 20));
    var hash = payload.sublist(20, 52);
    var verification = Verification(username, hash);
    var newTask = Task.deserialize(payload.sublist(52));
    return AddTaskRequest(verification, newTask);
  }
  return null;
}
