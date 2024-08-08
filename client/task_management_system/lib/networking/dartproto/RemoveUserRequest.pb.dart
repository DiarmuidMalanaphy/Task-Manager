//
//  Generated code. Do not modify.
//  source: RemoveUserRequest.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'Verification.pb.dart' as $2;

class RemoveUserRequest extends $pb.GeneratedMessage {
  factory RemoveUserRequest({
    $2.VerificationToken? token,
  }) {
    final $result = create();
    if (token != null) {
      $result.token = token;
    }
    return $result;
  }
  RemoveUserRequest._() : super();
  factory RemoveUserRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveUserRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RemoveUserRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'taskmanager.pb'), createEmptyInstance: create)
    ..aOM<$2.VerificationToken>(1, _omitFieldNames ? '' : 'token', subBuilder: $2.VerificationToken.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveUserRequest clone() => RemoveUserRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveUserRequest copyWith(void Function(RemoveUserRequest) updates) => super.copyWith((message) => updates(message as RemoveUserRequest)) as RemoveUserRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveUserRequest create() => RemoveUserRequest._();
  RemoveUserRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveUserRequest> createRepeated() => $pb.PbList<RemoveUserRequest>();
  @$core.pragma('dart2js:noInline')
  static RemoveUserRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveUserRequest>(create);
  static RemoveUserRequest? _defaultInstance;

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
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
