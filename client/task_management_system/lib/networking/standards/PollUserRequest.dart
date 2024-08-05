import 'base.dart';
import 'dart:typed_data';
import '../dartproto/PollUserRequest.pb.dart';

class PollUserRequest_Type {
  final Verification_Type verification;
  final int lastSeenTaskID;

  PollUserRequest_Type(this.verification, this.lastSeenTaskID);
  Uint8List get serialise {
    final request = PollUserRequest();
    request.verification = verification.toProto;
    request.lastseentaskID = lastSeenTaskID;

    return request.writeToBuffer();
  }
}
