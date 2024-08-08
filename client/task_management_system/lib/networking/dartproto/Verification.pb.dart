//
//  Generated code. Do not modify.
//  source: Verification.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'Hash.pb.dart' as $1;
import 'Username.pb.dart' as $0;

class InitialVerification extends $pb.GeneratedMessage {
  factory InitialVerification({
    $0.Username? username,
    $1.Hash? hash,
  }) {
    final $result = create();
    if (username != null) {
      $result.username = username;
    }
    if (hash != null) {
      $result.hash = hash;
    }
    return $result;
  }
  InitialVerification._() : super();
  factory InitialVerification.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory InitialVerification.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'InitialVerification', package: const $pb.PackageName(_omitMessageNames ? '' : 'taskmanager.pb'), createEmptyInstance: create)
    ..aOM<$0.Username>(1, _omitFieldNames ? '' : 'Username', protoName: 'Username', subBuilder: $0.Username.create)
    ..aOM<$1.Hash>(2, _omitFieldNames ? '' : 'Hash', protoName: 'Hash', subBuilder: $1.Hash.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  InitialVerification clone() => InitialVerification()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  InitialVerification copyWith(void Function(InitialVerification) updates) => super.copyWith((message) => updates(message as InitialVerification)) as InitialVerification;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InitialVerification create() => InitialVerification._();
  InitialVerification createEmptyInstance() => create();
  static $pb.PbList<InitialVerification> createRepeated() => $pb.PbList<InitialVerification>();
  @$core.pragma('dart2js:noInline')
  static InitialVerification getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<InitialVerification>(create);
  static InitialVerification? _defaultInstance;

  @$pb.TagNumber(1)
  $0.Username get username => $_getN(0);
  @$pb.TagNumber(1)
  set username($0.Username v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => clearField(1);
  @$pb.TagNumber(1)
  $0.Username ensureUsername() => $_ensure(0);

  @$pb.TagNumber(2)
  $1.Hash get hash => $_getN(1);
  @$pb.TagNumber(2)
  set hash($1.Hash v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasHash() => $_has(1);
  @$pb.TagNumber(2)
  void clearHash() => clearField(2);
  @$pb.TagNumber(2)
  $1.Hash ensureHash() => $_ensure(1);
}

class VerificationToken extends $pb.GeneratedMessage {
  factory VerificationToken({
    $core.List<$core.int>? token,
    $fixnum.Int64? userID,
    $fixnum.Int64? expires,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    if (userID != null) {
      $result.userID = userID;
    }
    if (expires != null) {
      $result.expires = expires;
    }
    return $result;
  }
  VerificationToken._() : super();
  factory VerificationToken.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VerificationToken.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VerificationToken', package: const $pb.PackageName(_omitMessageNames ? '' : 'taskmanager.pb'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, _omitFieldNames ? '' : 'token', $pb.PbFieldType.OY)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'userID', $pb.PbFieldType.OU6, protoName: 'userID', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'expires', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VerificationToken clone() => VerificationToken()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VerificationToken copyWith(void Function(VerificationToken) updates) => super.copyWith((message) => updates(message as VerificationToken)) as VerificationToken;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerificationToken create() => VerificationToken._();
  VerificationToken createEmptyInstance() => create();
  static $pb.PbList<VerificationToken> createRepeated() => $pb.PbList<VerificationToken>();
  @$core.pragma('dart2js:noInline')
  static VerificationToken getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VerificationToken>(create);
  static VerificationToken? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get token => $_getN(0);
  @$pb.TagNumber(1)
  set token($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get userID => $_getI64(1);
  @$pb.TagNumber(2)
  set userID($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserID() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserID() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get expires => $_getI64(2);
  @$pb.TagNumber(3)
  set expires($fixnum.Int64 v) { $_setInt64(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasExpires() => $_has(2);
  @$pb.TagNumber(3)
  void clearExpires() => clearField(3);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
