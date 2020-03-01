import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../dbKeys.dart' as db_key;
import '../screens/account/image_type.dart';

class StringHelper {
  static String getImageTypeString(ImageType type) {
    switch (type) {
      case ImageType.PROFILE:
        {
          return db_key.profileImageDBKey;
        }
        break;
      case ImageType.COVER:
        {
          return db_key.coverImageDBKey;
        }
        break;
      default:
        return '';
    }
  }

  static String getNonCollisionURL(String url) {
    return '$url?${DateTime.now().microsecondsSinceEpoch}';
  }

  static String dateFormatterNoTime(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  static String dateFormatterWithTime(DateTime date) {
    final DateFormat formatter = DateFormat.yMMMMd('en_US').add_jm();
    return formatter.format(date);
  }

  static String getPriceButtonText(RangeValues values) {
    return '\$${values.start.toInt().toString()} - \$${values.end.toInt().toString()}';
  }
}
