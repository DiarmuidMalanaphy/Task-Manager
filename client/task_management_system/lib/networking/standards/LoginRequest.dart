import 'base.dart';
import 'dart:typed_data';
import '../dartproto/LoginRequest.pb.dart';

class LoginRequest_Type {
  final Verification_Type verification;
  LoginRequest_Type(this.verification);

  Uint8List get serialise {
    final req = LoginRequest()..verification = verification.toProto;
    return req.writeToBuffer();
  }
}
