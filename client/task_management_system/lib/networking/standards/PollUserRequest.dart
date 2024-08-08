import 'package:fixnum/fixnum.dart';
import 'package:task_management_system/networking/standards/verification.dart';

import 'dart:typed_data';
import '../dartproto/PollUserRequest.pb.dart';

class PollUserRequest_Type {
  final Verification_Token_Type token;
  final Int64 lastSeenTaskID;

  PollUserRequest_Type(this.token, this.lastSeenTaskID);
  Uint8List get serialise {
    final request = PollUserRequest();
    request.token = token.toProto;
    request.lastseentaskID = lastSeenTaskID;

    return request.writeToBuffer();
  }
}
