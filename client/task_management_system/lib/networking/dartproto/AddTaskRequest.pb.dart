//
//  Generated code. Do not modify.
//  source: AddTaskRequest.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'Task.pb.dart' as $3;
import 'Verification.pb.dart' as $2;

class AddTaskRequest extends $pb.GeneratedMessage {
  factory AddTaskRequest({
    $2.Verification? verification,
    $3.Task? newtask,
  }) {
    final $result = create();
    if (verification != null) {
      $result.verification = verification;
    }
    if (newtask != null) {
      $result.newtask = newtask;
    }
    return $result;
  }
  AddTaskRequest._() : super();
  factory AddTaskRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddTaskRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddTaskRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'taskmanager.pb'), createEmptyInstance: create)
    ..aOM<$2.Verification>(1, _omitFieldNames ? '' : 'verification', subBuilder: $2.Verification.create)
    ..aOM<$3.Task>(2, _omitFieldNames ? '' : 'newtask', subBuilder: $3.Task.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddTaskRequest clone() => AddTaskRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddTaskRequest copyWith(void Function(AddTaskRequest) updates) => super.copyWith((message) => updates(message as AddTaskRequest)) as AddTaskRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddTaskRequest create() => AddTaskRequest._();
  AddTaskRequest createEmptyInstance() => create();
  static $pb.PbList<AddTaskRequest> createRepeated() => $pb.PbList<AddTaskRequest>();
  @$core.pragma('dart2js:noInline')
  static AddTaskRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddTaskRequest>(create);
  static AddTaskRequest? _defaultInstance;

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
  $3.Task get newtask => $_getN(1);
  @$pb.TagNumber(2)
  set newtask($3.Task v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasNewtask() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewtask() => clearField(2);
  @$pb.TagNumber(2)
  $3.Task ensureNewtask() => $_ensure(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
