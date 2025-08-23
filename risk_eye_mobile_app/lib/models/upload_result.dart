import 'package:json_annotation/json_annotation.dart';

part 'upload_result.g.dart';

@JsonSerializable()
class UploadResult {
  final String id;
  final String url;
  @JsonKey(name: 'uploaded_at')
  final DateTime uploadedAt;

  UploadResult({
    required this.id,
    required this.url,
    required this.uploadedAt,
  });

  factory UploadResult.fromJson(Map<String, dynamic> json) =>
      _$UploadResultFromJson(json);
  Map<String, dynamic> toJson() => _$UploadResultToJson(this);
}
