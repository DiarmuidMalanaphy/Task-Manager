import 'base.dart';
import 'dart:typed_data';
import '../dartproto/VerifyUserExistsRequest.pb.dart';

class VerifyUserExistsRequest_Type {
  final Username_Type username;

  VerifyUserExistsRequest_Type(this.username);

  Uint8List get serialise {
    final addTaskRequest = VerifyUserExistsRequest()
      ..username = username.toProto;
    return addTaskRequest.writeToBuffer();
  }
}
