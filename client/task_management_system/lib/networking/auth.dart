import 'package:hive/hive.dart';
import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';
import 'package:task_management_system/networking/standards/username.dart';
import 'package:task_management_system/networking/standards/verification.dart';
import 'package:task_management_system/networking/dartproto/Verification.pb.dart';

class Auth {
  static const String _boxName = 'gtd_box';
  static const String _authboxName = 'auth_box';
  static const String _baseVerificationKey = 'base_verification';
  static const String _verificationTokenKey = 'verification_token';
  static const String _ipAddressKey = 'ip_address';
  late Box<dynamic> _box;
  Auth() {
    _box = Hive.box(_boxName);
  }

  String get baseVerificationKey {
    return _authboxName + _baseVerificationKey;
  }

  String get verificationTokenKey {
    return _authboxName + _verificationTokenKey;
  }

  String get ipAddressKey {
    return _authboxName + _ipAddressKey;
  }

  void storeInitialVerification(
      Initialisation_Verification_Type baseVerification) {
    _box.put(baseVerificationKey, baseVerification.toProto.writeToBuffer());
  }

  void storeVerificationToken(Verification_Token_Type token) {
    _box.put(verificationTokenKey, token.toProto.writeToBuffer());
  }

  Initialisation_Verification_Type? getInitialVerification() {
    final data = _box.get(baseVerificationKey) as Uint8List?;
    if (data != null) {
      return Initialisation_Verification_Type.fromProto(
          InitialVerification.fromBuffer(data));
    }
    return null;
  }

  Verification_Token_Type? getVerificationToken() {
    final data = _box.get(verificationTokenKey) as Uint8List?;
    if (data != null) {
      return Verification_Token_Type.fromProto(data);
    }
    return null;
  }

  bool hasInitialVerification() {
    return _box.containsKey(baseVerificationKey);
  }

  bool hasVerificationToken() {
    return _box.containsKey(verificationTokenKey);
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
    _box.put(ipAddressKey, ipAddress);
  }

  String? getIPAddress() {
    return _box.get(ipAddressKey) as String?;
  }

  bool hasIPAddress() {
    return _box.containsKey(ipAddressKey);
  }

  void clearIPAddress() {
    _box.delete(ipAddressKey);
  }

  void clear() {
    _box.delete(baseVerificationKey);
    _box.delete(verificationTokenKey);
    _box.delete(ipAddressKey);
  }
}
