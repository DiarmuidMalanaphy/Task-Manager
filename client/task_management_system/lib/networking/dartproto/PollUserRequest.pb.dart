//
//  Generated code. Do not modify.
//  source: PollUserRequest.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'Verification.pb.dart' as $2;

class PollUserRequest extends $pb.GeneratedMessage {
  factory PollUserRequest({
    $2.VerificationToken? token,
    $fixnum.Int64? lastseentaskID,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    if (lastseentaskID != null) {
      $result.lastseentaskID = lastseentaskID;
    }
    return $result;
  }
  PollUserRequest._() : super();
  factory PollUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PollUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PollUserRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'taskmanager.pb'), createEmptyInstance: create)
    ..aOM<$2.VerificationToken>(1, _omitFieldNames ? '' : 'token', subBuilder: $2.VerificationToken.create)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'lastseentaskID', $pb.PbFieldType.OU6, protoName: 'lastseentaskID', defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PollUserRequest clone() => PollUserRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PollUserRequest copyWith(void Function(PollUserRequest) updates) => super.copyWith((message) => updates(message as PollUserRequest)) as PollUserRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PollUserRequest create() => PollUserRequest._();
  PollUserRequest createEmptyInstance() => create();
  static $pb.PbList<PollUserRequest> createRepeated() => $pb.PbList<PollUserRequest>();
  @$core.pragma('dart2js:noInline')
  static PollUserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PollUserRequest>(create);
  static PollUserRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.VerificationToken get token => $_getN(0);
  @$pb.TagNumber(1)
  set token($2.VerificationToken v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearToken() => clearField(1);
  @$pb.TagNumber(1)
  $2.VerificationToken ensureToken() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get lastseentaskID => $_getI64(1);
  @$pb.TagNumber(2)
  set lastseentaskID($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLastseentaskID() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastseentaskID() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
