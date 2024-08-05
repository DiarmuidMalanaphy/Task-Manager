import 'dart:typed_data';
import 'dart:convert';
import '../dartproto/Error.pb.dart';

class Error_Type {
  static const int PROTOSIZE = 62;
  static const int SIZE = 60;

  String errorMessage;

  Error_Type(this.errorMessage) {
    if (utf8.encode(errorMessage).length > SIZE) {
      throw ArgumentError('Error message too long');
    }
    errorMessage = errorMessage;
  }

  Uint8List serialize() {
    var buffer = Uint8List(SIZE);
    var messageBytes = utf8.encode(errorMessage);
    buffer.setAll(0, messageBytes);
    return buffer;
  }

  static Error_Type deserialize(Uint8List data) {
    if (data.length == PROTOSIZE) {
      data = data.sublist(2);
    }
    if (data.length != SIZE) {
      throw ArgumentError('Invalid data length for Error deserialization');
    }

    var errorMessage = utf8.decode(data.where((byte) => byte != 0).toList());
    return Error_Type(errorMessage);
  }

  static Error_Type fromBuffer(Uint8List buffer) {
    var error = Error.fromBuffer(buffer);
    var errorMessage =
        utf8.decode(error.error.where((byte) => byte != 0).toList());
    return Error_Type(errorMessage);
  }
}
