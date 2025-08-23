import 'package:flutter/foundation.dart';

@immutable
class UploadSources {
  const UploadSources({
    required this.idCard,
    required this.bankStatement,
    required this.propertyDoc,
  });

  final bool idCard;
  final bool bankStatement;
  final bool propertyDoc;

  factory UploadSources.fromJson(Map<String, dynamic> json) => UploadSources(
        idCard: json['id_card'] as bool? ?? false,
        bankStatement: json['bank_statement'] as bool? ?? false,
        propertyDoc: json['property_doc'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id_card': idCard,
        'bank_statement': bankStatement,
        'property_doc': propertyDoc,
      };
}
