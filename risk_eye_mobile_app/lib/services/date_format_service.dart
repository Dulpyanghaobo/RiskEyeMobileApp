import 'package:intl/intl.dart';

class DateFormatService {
  String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  String formatDateTime(DateTime date) =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
}
