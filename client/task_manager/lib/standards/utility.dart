import 'dart:typed_data';

int getUint16(Uint8List data, int offset) {
  return ByteData.sublistView(data, offset, offset + 2).getUint16(0, Endian.little);
}

int getUint32(Uint8List data, int offset) {
  return ByteData.sublistView(data, offset, offset + 4).getUint32(0, Endian.little);
}

int getUint64(Uint8List data, int offset) {
  return ByteData.sublistView(data, offset, offset + 8).getUint64(0, Endian.little);
}
