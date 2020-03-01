import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:physio_tracker_app/helpers/stringHelper.dart';
import 'package:intl/intl.dart';

class DateTimeHelper {
  static DateTime timeStampToDateTime(Timestamp timestamp) {
    return timestamp.toDate();
  }

  static String getTimeLineFrom(Timestamp startTimeStamp, Timestamp endTimeStamp) {
    if (startTimeStamp == null || endTimeStamp == null)
      return '';

    final DateTime startDate = timeStampToDateTime(startTimeStamp);
    final DateTime endDate = timeStampToDateTime(endTimeStamp);

    return '${StringHelper.dateFormatterNoTime(startDate)} '
        ' to '
        '${StringHelper.dateFormatterNoTime(endDate)}';
  }

  static String dateTimeToString(DateTime dateTime) {
    if (dateTime == null)
      return '';
    final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    return inputFormat.format(dateTime);
  }

  static DateTime stringToDateTime(String string) {
    final DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    return inputFormat.parse(string);
  }
}