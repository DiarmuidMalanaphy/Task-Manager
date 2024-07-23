import 'dart:typed_data';
import 'dart:convert';

class Error {
  static const int SIZE = 60;

  final String errorMessage;

  Error(this.errorMessage) {
    if (utf8.encode(errorMessage).length > SIZE) {
      throw ArgumentError('Error message too long');
    }
  }

  Uint8List serialize() {
    var buffer = Uint8List(SIZE);
    var messageBytes = utf8.encode(errorMessage);
    buffer.setAll(0, messageBytes);
    return buffer;
  }

  static Error deserialize(Uint8List data) {
    if (data.length != SIZE) {
      throw ArgumentError('Invalid data length for Error deserialization');
    }

    var message = utf8.decode(data.where((byte) => byte != 0).toList());
    return Error(message);
  }
}
