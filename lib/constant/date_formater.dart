import 'package:intl/intl.dart';

class DataFormatter {
  static String formatDateFromIsoString(String isoString) {
    DateTime date = DateTime.parse(isoString);
    final formatter = DateFormat('MMMM d, yyyy');
    return formatter.format(date);
  }
}
