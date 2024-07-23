import 'dart:typed_data';
import 'dart:convert';
import 'package:crypto/crypto.dart';

int getUint16(Uint8List data, int offset) {
  return ByteData.sublistView(data, offset, offset + 2)
      .getUint16(0, Endian.little);
}

int getUint32(Uint8List data, int offset) {
  return ByteData.sublistView(data, offset, offset + 4)
      .getUint32(0, Endian.little);
}

int getUint64(Uint8List data, int offset) {
  return ByteData.sublistView(data, offset, offset + 8)
      .getUint64(0, Endian.little);
}

Uint8List createHash(String password) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return Uint8List.fromList(digest.bytes);
}

Uint8List stringToByteArray(String s, int size) {
  var result = Uint8List(size);
  var bytes = utf8.encode(s);
  result.setAll(0, bytes.take(size));
  return result;
}

Uint8List stringTo120ByteArray(String s) => stringToByteArray(s, 120);
Uint8List intToUint8(int num) {
  if (num < 0 || num > 255) {
    throw ArgumentError("Uint8 Cannot be greater than 255 or less than 0");
  }
  Uint8List result = Uint8List(1);
  result[0] = num;
  return result;
}
