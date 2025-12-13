import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatForApi(DateTime date) {
    return date.toIso8601String();
  }

  static DateTime parse(String dateString) {
    return DateTime.parse(dateString);
  }
}