//
//  Generated code. Do not modify.
//  source: VerifyUserExistsRequest.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'Username.pb.dart' as $0;

class VerifyUserExistsRequest extends $pb.GeneratedMessage {
  factory VerifyUserExistsRequest({
    $0.Username? username,
  }) {
    final $result = create();
    if (username != null) {
      $result.username = username;
    }
    return $result;
  }
  VerifyUserExistsRequest._() : super();
  factory VerifyUserExistsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VerifyUserExistsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VerifyUserExistsRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'taskmanager.pb'), createEmptyInstance: create)
    ..aOM<$0.Username>(1, _omitFieldNames ? '' : 'username', subBuilder: $0.Username.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  VerifyUserExistsRequest clone() => VerifyUserExistsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  VerifyUserExistsRequest copyWith(void Function(VerifyUserExistsRequest) updates) => super.copyWith((message) => updates(message as VerifyUserExistsRequest)) as VerifyUserExistsRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VerifyUserExistsRequest create() => VerifyUserExistsRequest._();
  VerifyUserExistsRequest createEmptyInstance() => create();
  static $pb.PbList<VerifyUserExistsRequest> createRepeated() => $pb.PbList<VerifyUserExistsRequest>();
  @$core.pragma('dart2js:noInline')
  static VerifyUserExistsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VerifyUserExistsRequest>(create);
  static VerifyUserExistsRequest? _defaultInstance;

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
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
