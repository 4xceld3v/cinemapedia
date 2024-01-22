import 'package:intl/intl.dart';

class DateFormats {
  static const String dateFormat = 'dd/MM/yyyy';
  static String formatDate(DateTime date) {
    return DateFormat(dateFormat).format(date);
  }
}