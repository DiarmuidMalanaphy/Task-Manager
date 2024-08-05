import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';
import '../dartproto/request.pb.dart';

class Request_Type {
  final int type;
  final int payloadLength;
  final Uint8List payload;

  Request_Type(this.type, this.payloadLength, this.payload);
}

Uint8List serialiseRequest(int requestType, Uint8List payload) {
  // Calculate the total length: 1 byte for type + 4 bytes for length + payload length
  Request request = Request();
  print("Type is $requestType");
  request.type = requestType;
  request.payloadSize = Int64(payload.length);
  request.payload = payload;
  return request.writeToBuffer();
}

Request deserialiseRequest(Uint8List requestData) {
  // Use the fromBuffer method to deserialize the protobuf message
  return Request.fromBuffer(requestData);
}
