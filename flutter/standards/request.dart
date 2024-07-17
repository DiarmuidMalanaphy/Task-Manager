import 'dart:typed_data';
import 'utility.dart';



class Request {
  final int type;
  final int payloadLength;
  final Uint8List payload;

  Request(this.type, this.payloadLength, this.payload);
}



Uint8List serialiseRequest(int requestType, Uint8List payload) {
  // Calculate the total length: 1 byte for type + 4 bytes for length + payload length
  var payloadLength = payload.length;
  int totalLength = 1 + 4 + payload.length;
  
  // Create a ByteData buffer to write our data
  var buffer = ByteData(totalLength);
  
  // Write the type (1 byte)
  buffer.setUint8(0, requestType);
  
  // Write the payload length (4 bytes, little-endian)
  buffer.setUint32(1, payloadLength, Endian.little);
  
  // Copy the payload into the buffer
  Uint8List result = buffer.buffer.asUint8List();
  result.setRange(5, totalLength, payload);
  
  return result;
}

Request? deserialiseRequest(Uint8List request_data) {
  int type = request_data[0];
  int payloadLength = getUint32(request_data, 1);
  Uint8List payload = request_data.sublist(5, 5 + payloadLength);
  return Request(type, payloadLength, payload);
}




