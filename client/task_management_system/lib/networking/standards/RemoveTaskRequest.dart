import 'base.dart';
import 'dart:typed_data';
import '../dartproto/RemoveTaskRequest.pb.dart';
import 'package:fixnum/fixnum.dart';

class RemoveTaskRequest_Type {
  final Verification_Type verification;
  final int taskID;

  RemoveTaskRequest_Type(this.verification, this.taskID);

  Uint8List get serialise {
    final removeTaskRequest = RemoveTaskRequest()
      ..verification = verification.toProto
      ..taskID = Int64(taskID);
    return removeTaskRequest.writeToBuffer();
  }
}
