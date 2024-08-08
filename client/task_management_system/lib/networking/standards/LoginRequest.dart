import 'verification.dart';
import 'dart:typed_data';
import '../dartproto/LoginRequest.pb.dart';

class LoginRequest_Type {
  final Initialisation_Verification_Type verification;
  LoginRequest_Type(this.verification);

  Uint8List get serialise {
    final req = LoginRequest()..initialverification = verification.toProto;
    return req.writeToBuffer();
  }
}
