import 'package:intl/intl.dart';

class DateFormats {
  static const String dateFormat = 'dd/MM/yyyy';
  static String formatDate(DateTime? date) {
    
    return date  != null && date.toString().isNotEmpty 
    ? DateFormat(dateFormat).format(date) 
    : 'Sin fecha de estreno' ;
  }
}