import 'verification.dart';
import 'dart:typed_data';
import '../dartproto/RemoveTaskRequest.pb.dart';
import 'package:fixnum/fixnum.dart';

class RemoveTaskRequest_Type {
  final Verification_Token_Type token;
  final int taskID;

  RemoveTaskRequest_Type(this.token, this.taskID);

  Uint8List get serialise {
    final removeTaskRequest = RemoveTaskRequest()
      ..token = token.toProto
      ..taskID = Int64(taskID);
    return removeTaskRequest.writeToBuffer();
  }
}
