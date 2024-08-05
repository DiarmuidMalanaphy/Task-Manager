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

import 'package:protobuf/protobuf.dart' as $pb;

import 'Hash.pb.dart' as $1;
import 'Username.pb.dart' as $0;

class Verification extends $pb.GeneratedMessage {
  factory Verification({
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
  Verification._() : super();
  factory Verification.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Verification.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Verification', package: const $pb.PackageName(_omitMessageNames ? '' : 'taskmanager.pb'), createEmptyInstance: create)
    ..aOM<$0.Username>(1, _omitFieldNames ? '' : 'Username', protoName: 'Username', subBuilder: $0.Username.create)
    ..aOM<$1.Hash>(2, _omitFieldNames ? '' : 'Hash', protoName: 'Hash', subBuilder: $1.Hash.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Verification clone() => Verification()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Verification copyWith(void Function(Verification) updates) => super.copyWith((message) => updates(message as Verification)) as Verification;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Verification create() => Verification._();
  Verification createEmptyInstance() => create();
  static $pb.PbList<Verification> createRepeated() => $pb.PbList<Verification>();
  @$core.pragma('dart2js:noInline')
  static Verification getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Verification>(create);
  static Verification? _defaultInstance;

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


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
