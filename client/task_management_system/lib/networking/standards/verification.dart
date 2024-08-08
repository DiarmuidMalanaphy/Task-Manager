import 'package:task_management_system/networking/dartproto/Verification.pb.dart';
import 'package:task_management_system/networking/standards/hash.dart';
import 'package:fixnum/fixnum.dart';
import 'package:task_management_system/networking/standards/username.dart';
import 'dart:typed_data';

class Initialisation_Verification_Type {
  final Username_Type username;
  final Hash_Type hash;

  Initialisation_Verification_Type(this.username, this.hash);

  Initialisation_Verification_Type.fromProto(InitialVerification proto)
      : username = Username_Type.fromProto(proto.username),
        hash = Hash_Type.fromProto(proto.hash);

  InitialVerification get toProto {
    InitialVerification verification = InitialVerification();
    verification.username = username.toProto;
    verification.hash = hash.toProto;

    return verification;
  }
}

class Verification_Token_Type {
  Uint8List _token;
  Int64 _userID;
  Int64 _expiryDate;

  Verification_Token_Type.fromProto(Uint8List bytes)
      : _token = Uint8List(0),
        _userID = Int64(0),
        _expiryDate = Int64(0) {
    final fullToken = VerificationToken.fromBuffer(bytes);
    _token = Uint8List.fromList(fullToken.token);
    _userID = fullToken.userID;
    _expiryDate = fullToken.expires;
  }

  VerificationToken get toProto {
    return VerificationToken()
      ..token = _token
      ..userID = _userID
      ..expires = _expiryDate;
  }

  bool get withinDate {
    final now = DateTime.now().millisecondsSinceEpoch;
    return _expiryDate >
        Int64(
            now ~/ 1000); // Convert milliseconds to seconds for UNIX timestamp
  }

  Uint8List get token => _token;
  Int64 get userID => _userID;
  Int64 get expiryDate => _expiryDate;
}
