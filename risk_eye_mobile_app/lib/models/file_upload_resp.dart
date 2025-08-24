class FileUploadResp {
  final String fileId;
  final String url;

  FileUploadResp({required this.fileId, required this.url});

  factory FileUploadResp.fromJson(Map<String, dynamic> json) {
    return FileUploadResp(
      fileId: json['fileId'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'fileId': fileId,
        'url': url,
      };
}
