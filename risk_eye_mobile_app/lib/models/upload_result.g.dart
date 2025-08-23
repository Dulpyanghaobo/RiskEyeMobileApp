// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_result.dart';

UploadResult _$UploadResultFromJson(Map<String, dynamic> json) => UploadResult(
      id: json['id'] as String,
      url: json['url'] as String,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
    );

Map<String, dynamic> _$UploadResultToJson(UploadResult instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'uploaded_at': instance.uploadedAt.toIso8601String(),
    };

