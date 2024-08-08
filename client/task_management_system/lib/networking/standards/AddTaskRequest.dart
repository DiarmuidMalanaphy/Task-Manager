import 'package:task_management_system/networking/standards/verification.dart';

import 'dart:typed_data';
import 'Task.dart';
import '../dartproto/AddTaskRequest.pb.dart';

class AddTaskRequest_Type {
  final Verification_Token_Type token;
  final Task_Type newTask;

  AddTaskRequest_Type(this.token, this.newTask);

  Uint8List get serialise {
    final addTaskRequest = AddTaskRequest()
      ..token = token.toProto
      ..newtask = newTask.toProto;
    return addTaskRequest.writeToBuffer();
  }
}
