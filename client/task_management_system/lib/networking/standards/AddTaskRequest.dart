import 'base.dart';
import 'dart:typed_data';
import 'Task.dart';
import '../dartproto/AddTaskRequest.pb.dart';

class AddTaskRequest_Type {
  final Verification_Type verification;
  final Task_Type newTask;

  AddTaskRequest_Type(this.verification, this.newTask);

  Uint8List get serialise {
    final addTaskRequest = AddTaskRequest()
      ..verification = verification.toProto
      ..newtask = newTask.toProto;
    return addTaskRequest.writeToBuffer();
  }
}
