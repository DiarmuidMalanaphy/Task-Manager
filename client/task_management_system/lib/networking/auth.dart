import 'package:hive/hive.dart';
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';
import 'package:task_management_system/networking/standards/username.dart';
import 'package:task_management_system/networking/standards/verification.dart';
import 'package:task_management_system/networking/dartproto/Verification.pb.dart';

class Auth {
  static const String _boxName = 'auth_box';
  static const String _baseVerificationKey = 'base_verification';
  static const String _verificationTokenKey = 'verification_token';
  static const String _ipAddressKey = 'ip_address';
  late Box<dynamic> _box;
  Auth() {
    _box = Hive.box(_boxName);
  }
  void storeInitialVerification(
      Initialisation_Verification_Type baseVerification) {
    _box.put(_baseVerificationKey, baseVerification.toProto.writeToBuffer());
  }

  void storeVerificationToken(Verification_Token_Type token) {
    _box.put(_verificationTokenKey, token.toProto.writeToBuffer());
  }

  Initialisation_Verification_Type? getInitialVerification() {
    final data = _box.get(_baseVerificationKey) as Uint8List?;
    if (data != null) {
      return Initialisation_Verification_Type.fromProto(
          InitialVerification.fromBuffer(data));
    }
    return null;
  }

  Verification_Token_Type? getVerificationToken() {
    final data = _box.get(_verificationTokenKey) as Uint8List?;
    if (data != null) {
      return Verification_Token_Type.fromProto(data);
    }
    return null;
  }

  bool hasInitialVerification() {
    return _box.containsKey(_baseVerificationKey);
  }

  bool hasVerificationToken() {
    return _box.containsKey(_verificationTokenKey);
  }

  bool isTokenValid() {
    final token = getVerificationToken();
    return token?.withinDate ?? false;
  }

  Username_Type? getUsername() {
    return getInitialVerification()?.username;
  }

  Int64? getUserID() {
    return getVerificationToken()?.userID;
  }

  void setIPAddress(String ipAddress) {
    _box.put(_ipAddressKey, ipAddress);
  }

  String? getIPAddress() {
    return _box.get(_ipAddressKey) as String?;
  }

  bool hasIPAddress() {
    return _box.containsKey(_ipAddressKey);
  }

  void clearIPAddress() {
    _box.delete(_ipAddressKey);
  }

  void clear() {
    _box.delete(_baseVerificationKey);
    _box.delete(_verificationTokenKey);
    _box.delete(_ipAddressKey);
  }
}
