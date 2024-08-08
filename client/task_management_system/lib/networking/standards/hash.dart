import 'package:task_management_system/networking/standards/password.dart';
import 'dart:typed_data';
import 'dart:convert';
import '../dartproto/Hash.pb.dart';

class Hash_Type {
  final Uint8List _bytes;

  Hash_Type(Password password) : _bytes = password.hash;
  Hash_Type.fromString(String hashString) : _bytes = base64Decode(hashString);
  Hash_Type.fromProto(Hash proto) : _bytes = Uint8List.fromList(proto.hash);

  Hash get toProto {
    var hash = Hash()..hash = _bytes;
    return hash;
  }

  @override
  String toString() {
    return base64Encode(_bytes);
  }
}
