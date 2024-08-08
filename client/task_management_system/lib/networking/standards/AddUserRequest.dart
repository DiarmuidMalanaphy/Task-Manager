import 'package:task_management_system/networking/standards/verification.dart';

import 'username.dart';
import 'password.dart';
import 'dart:typed_data';
import 'hash.dart';
import '../dartproto/AddUserRequest.pb.dart';

class AddUserRequest_Type {
  final Initialisation_Verification_Type verification;

  AddUserRequest_Type(String username, String password)
      : verification = Initialisation_Verification_Type(
            Username_Type.fromString(username),
            Hash_Type(Password.fromString(password)));

  Uint8List get serialise {
    final addUserRequest = AddUserRequest()
      ..verification = verification.toProto;

    return addUserRequest.writeToBuffer();
  }
}
