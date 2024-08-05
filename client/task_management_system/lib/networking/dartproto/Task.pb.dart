//
//  Generated code. Do not modify.
//  source: Task.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'Username.pb.dart' as $0;

class Task extends $pb.GeneratedMessage {
  factory Task({
    $fixnum.Int64? taskID,
    $0.Username? taskName,
    $0.Username? targetUsername,
    $0.Username? setterUsername,
    $core.int? status,
    $core.List<$core.int>? taskDescription,
    $fixnum.Int64? filterone,
    $fixnum.Int64? filtertwo,
  }) {
    final $result = create();
    if (taskID != null) {
      $result.taskID = taskID;
    }
    if (taskName != null) {
      $result.taskName = taskName;
    }
    if (targetUsername != null) {
      $result.targetUsername = targetUsername;
    }
    if (setterUsername != null) {
      $result.setterUsername = setterUsername;
    }
    if (status != null) {
      $result.status = status;
    }
    if (taskDescription != null) {
      $result.taskDescription = taskDescription;
    }
    if (filterone != null) {
      $result.filterone = filterone;
    }
    if (filtertwo != null) {
      $result.filtertwo = filtertwo;
    }
    return $result;
  }
  Task._() : super();
  factory Task.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Task.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Task', package: const $pb.PackageName(_omitMessageNames ? '' : 'taskmanager.pb'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'taskID', $pb.PbFieldType.OU6, protoName: 'taskID', defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$0.Username>(2, _omitFieldNames ? '' : 'taskName', protoName: 'taskName', subBuilder: $0.Username.create)
    ..aOM<$0.Username>(3, _omitFieldNames ? '' : 'targetUsername', protoName: 'targetUsername', subBuilder: $0.Username.create)
    ..aOM<$0.Username>(4, _omitFieldNames ? '' : 'setterUsername', protoName: 'setterUsername', subBuilder: $0.Username.create)
    ..a<$core.int>(5, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(6, _omitFieldNames ? '' : 'taskDescription', $pb.PbFieldType.OY, protoName: 'taskDescription')
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'filterone', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(8, _omitFieldNames ? '' : 'filtertwo', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Task clone() => Task()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Task copyWith(void Function(Task) updates) => super.copyWith((message) => updates(message as Task)) as Task;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Task create() => Task._();
  Task createEmptyInstance() => create();
  static $pb.PbList<Task> createRepeated() => $pb.PbList<Task>();
  @$core.pragma('dart2js:noInline')
  static Task getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Task>(create);
  static Task? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get taskID => $_getI64(0);
  @$pb.TagNumber(1)
  set taskID($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTaskID() => $_has(0);
  @$pb.TagNumber(1)
  void clearTaskID() => clearField(1);

  @$pb.TagNumber(2)
  $0.Username get taskName => $_getN(1);
  @$pb.TagNumber(2)
  set taskName($0.Username v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasTaskName() => $_has(1);
  @$pb.TagNumber(2)
  void clearTaskName() => clearField(2);
  @$pb.TagNumber(2)
  $0.Username ensureTaskName() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Username get targetUsername => $_getN(2);
  @$pb.TagNumber(3)
  set targetUsername($0.Username v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTargetUsername() => $_has(2);
  @$pb.TagNumber(3)
  void clearTargetUsername() => clearField(3);
  @$pb.TagNumber(3)
  $0.Username ensureTargetUsername() => $_ensure(2);

  @$pb.TagNumber(4)
  $0.Username get setterUsername => $_getN(3);
  @$pb.TagNumber(4)
  set setterUsername($0.Username v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasSetterUsername() => $_has(3);
  @$pb.TagNumber(4)
  void clearSetterUsername() => clearField(4);
  @$pb.TagNumber(4)
  $0.Username ensureSetterUsername() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get status => $_getIZ(4);
  @$pb.TagNumber(5)
  set status($core.int v) { $_setUnsignedInt32(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => clearField(5);

  @$pb.TagNumber(6)
  $core.List<$core.int> get taskDescription => $_getN(5);
  @$pb.TagNumber(6)
  set taskDescription($core.List<$core.int> v) { $_setBytes(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasTaskDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearTaskDescription() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get filterone => $_getI64(6);
  @$pb.TagNumber(7)
  set filterone($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasFilterone() => $_has(6);
  @$pb.TagNumber(7)
  void clearFilterone() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get filtertwo => $_getI64(7);
  @$pb.TagNumber(8)
  set filtertwo($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasFiltertwo() => $_has(7);
  @$pb.TagNumber(8)
  void clearFiltertwo() => clearField(8);
}

class TaskList extends $pb.GeneratedMessage {
  factory TaskList({
    $core.Iterable<Task>? tasks,
  }) {
    final $result = create();
    if (tasks != null) {
      $result.tasks.addAll(tasks);
    }
    return $result;
  }
  TaskList._() : super();
  factory TaskList.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TaskList.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'TaskList', package: const $pb.PackageName(_omitMessageNames ? '' : 'taskmanager.pb'), createEmptyInstance: create)
    ..pc<Task>(1, _omitFieldNames ? '' : 'tasks', $pb.PbFieldType.PM, subBuilder: Task.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  TaskList clone() => TaskList()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  TaskList copyWith(void Function(TaskList) updates) => super.copyWith((message) => updates(message as TaskList)) as TaskList;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TaskList create() => TaskList._();
  TaskList createEmptyInstance() => create();
  static $pb.PbList<TaskList> createRepeated() => $pb.PbList<TaskList>();
  @$core.pragma('dart2js:noInline')
  static TaskList getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TaskList>(create);
  static TaskList? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Task> get tasks => $_getList(0);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
