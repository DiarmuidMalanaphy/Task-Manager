//
//  Generated code. Do not modify.
//  source: Task.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use taskDescriptor instead')
const Task$json = {
  '1': 'Task',
  '2': [
    {'1': 'taskID', '3': 1, '4': 1, '5': 4, '10': 'taskID'},
    {'1': 'taskName', '3': 2, '4': 1, '5': 11, '6': '.taskmanager.pb.Username', '10': 'taskName'},
    {'1': 'targetUsername', '3': 3, '4': 1, '5': 11, '6': '.taskmanager.pb.Username', '10': 'targetUsername'},
    {'1': 'setterUsername', '3': 4, '4': 1, '5': 11, '6': '.taskmanager.pb.Username', '10': 'setterUsername'},
    {'1': 'status', '3': 5, '4': 1, '5': 13, '10': 'status'},
    {'1': 'taskDescription', '3': 6, '4': 1, '5': 12, '10': 'taskDescription'},
    {'1': 'filterone', '3': 7, '4': 1, '5': 4, '10': 'filterone'},
    {'1': 'filtertwo', '3': 8, '4': 1, '5': 4, '10': 'filtertwo'},
  ],
};

/// Descriptor for `Task`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taskDescriptor = $convert.base64Decode(
    'CgRUYXNrEhYKBnRhc2tJRBgBIAEoBFIGdGFza0lEEjQKCHRhc2tOYW1lGAIgASgLMhgudGFza2'
    '1hbmFnZXIucGIuVXNlcm5hbWVSCHRhc2tOYW1lEkAKDnRhcmdldFVzZXJuYW1lGAMgASgLMhgu'
    'dGFza21hbmFnZXIucGIuVXNlcm5hbWVSDnRhcmdldFVzZXJuYW1lEkAKDnNldHRlclVzZXJuYW'
    '1lGAQgASgLMhgudGFza21hbmFnZXIucGIuVXNlcm5hbWVSDnNldHRlclVzZXJuYW1lEhYKBnN0'
    'YXR1cxgFIAEoDVIGc3RhdHVzEigKD3Rhc2tEZXNjcmlwdGlvbhgGIAEoDFIPdGFza0Rlc2NyaX'
    'B0aW9uEhwKCWZpbHRlcm9uZRgHIAEoBFIJZmlsdGVyb25lEhwKCWZpbHRlcnR3bxgIIAEoBFIJ'
    'ZmlsdGVydHdv');

@$core.Deprecated('Use taskListDescriptor instead')
const TaskList$json = {
  '1': 'TaskList',
  '2': [
    {'1': 'tasks', '3': 1, '4': 3, '5': 11, '6': '.taskmanager.pb.Task', '10': 'tasks'},
  ],
};

/// Descriptor for `TaskList`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List taskListDescriptor = $convert.base64Decode(
    'CghUYXNrTGlzdBIqCgV0YXNrcxgBIAMoCzIULnRhc2ttYW5hZ2VyLnBiLlRhc2tSBXRhc2tz');

