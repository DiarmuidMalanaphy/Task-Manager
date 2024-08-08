//
//  Generated code. Do not modify.
//  source: Verification.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use initialVerificationDescriptor instead')
const InitialVerification$json = {
  '1': 'InitialVerification',
  '2': [
    {'1': 'Username', '3': 1, '4': 1, '5': 11, '6': '.taskmanager.pb.Username', '10': 'Username'},
    {'1': 'Hash', '3': 2, '4': 1, '5': 11, '6': '.taskmanager.pb.Hash', '10': 'Hash'},
  ],
};

/// Descriptor for `InitialVerification`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List initialVerificationDescriptor = $convert.base64Decode(
    'ChNJbml0aWFsVmVyaWZpY2F0aW9uEjQKCFVzZXJuYW1lGAEgASgLMhgudGFza21hbmFnZXIucG'
    'IuVXNlcm5hbWVSCFVzZXJuYW1lEigKBEhhc2gYAiABKAsyFC50YXNrbWFuYWdlci5wYi5IYXNo'
    'UgRIYXNo');

@$core.Deprecated('Use verificationTokenDescriptor instead')
const VerificationToken$json = {
  '1': 'VerificationToken',
  '2': [
    {'1': 'token', '3': 1, '4': 1, '5': 12, '10': 'token'},
    {'1': 'userID', '3': 2, '4': 1, '5': 4, '10': 'userID'},
    {'1': 'expires', '3': 3, '4': 1, '5': 4, '10': 'expires'},
  ],
};

/// Descriptor for `VerificationToken`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List verificationTokenDescriptor = $convert.base64Decode(
    'ChFWZXJpZmljYXRpb25Ub2tlbhIUCgV0b2tlbhgBIAEoDFIFdG9rZW4SFgoGdXNlcklEGAIgAS'
    'gEUgZ1c2VySUQSGAoHZXhwaXJlcxgDIAEoBFIHZXhwaXJlcw==');

