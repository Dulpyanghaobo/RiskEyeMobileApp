enum ExportFormat {
  pdf,
  xlsx,
}

extension ExportFormatX on ExportFormat {
  String get label {
    switch (this) {
      case ExportFormat.pdf:
        return 'PDF';
      case ExportFormat.xlsx:
        return 'Excel';
    }
  }

  static ExportFormat fromName(String? name) {
    return ExportFormat.values
        .firstWhere((e) => e.name == name, orElse: () => ExportFormat.pdf);
  }
}
