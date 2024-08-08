import 'verification.dart';
import '../dartproto/RemoveAllTasksRequest.pb.dart';
import 'dart:typed_data';

class RemoveAllTasksRequest_Type {
  final Verification_Token_Type token;
  RemoveAllTasksRequest_Type(this.token);

  Uint8List get serialise {
    final removeAllTasksRequest = RemoveAllTasksRequest()
      ..token = token.toProto;
    return removeAllTasksRequest.writeToBuffer();
  }
}
