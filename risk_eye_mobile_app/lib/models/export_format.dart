enum ExportFormat { pdf, xlsx }

extension ExportFormatX on ExportFormat {
  String get label {
    switch (this) {
      case ExportFormat.pdf:
        return 'PDF';
      case ExportFormat.xlsx:
        return 'Excel';
    }
    // 补充默认返回值，防止警告
    return '';
  }

  static ExportFormat fromName(String? name) {
    return ExportFormat.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ExportFormat.pdf,
    );
  }
}
