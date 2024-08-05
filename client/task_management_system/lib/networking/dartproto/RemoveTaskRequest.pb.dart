//
//  Generated code. Do not modify.
//  source: RemoveTaskRequest.proto
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

class RemoveTaskRequest extends $pb.GeneratedMessage {
  factory RemoveTaskRequest({
    $2.Verification? verification,
    $fixnum.Int64? taskID,
  }) {
    final $result = create();
    if (verification != null) {
      $result.verification = verification;
    }
    if (taskID != null) {
      $result.taskID = taskID;
    }
    return $result;
  }
  RemoveTaskRequest._() : super();
  factory RemoveTaskRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RemoveTaskRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RemoveTaskRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'taskmanager.pb'), createEmptyInstance: create)
    ..aOM<$2.Verification>(1, _omitFieldNames ? '' : 'verification', subBuilder: $2.Verification.create)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'TaskID', $pb.PbFieldType.OU6, protoName: 'TaskID', defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RemoveTaskRequest clone() => RemoveTaskRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RemoveTaskRequest copyWith(void Function(RemoveTaskRequest) updates) => super.copyWith((message) => updates(message as RemoveTaskRequest)) as RemoveTaskRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RemoveTaskRequest create() => RemoveTaskRequest._();
  RemoveTaskRequest createEmptyInstance() => create();
  static $pb.PbList<RemoveTaskRequest> createRepeated() => $pb.PbList<RemoveTaskRequest>();
  @$core.pragma('dart2js:noInline')
  static RemoveTaskRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RemoveTaskRequest>(create);
  static RemoveTaskRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Verification get verification => $_getN(0);
  @$pb.TagNumber(1)
  set verification($2.Verification v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasVerification() => $_has(0);
  @$pb.TagNumber(1)
  void clearVerification() => clearField(1);
  @$pb.TagNumber(1)
  $2.Verification ensureVerification() => $_ensure(0);

  @$pb.TagNumber(2)
  $fixnum.Int64 get taskID => $_getI64(1);
  @$pb.TagNumber(2)
  set taskID($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTaskID() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskID() => clearField(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
