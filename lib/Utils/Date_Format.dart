import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter(String s);

  /// Format a [DateTime] into 'dd/MM/yyyy' string
  static String format(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Try to parse a string in 'dd/MM/yyyy' format into DateTime
  static DateTime? parse(String dateString) {
    try {
      return DateFormat('dd/MM/yyyy').parseStrict(dateString);
    } catch (e) {
      return null;
    }
  }
}
