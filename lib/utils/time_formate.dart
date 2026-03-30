
import 'package:intl/intl.dart';

class TimeFormatHelper {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM, yyyy').format(date);
  }

  static String formatFullMonthDate(DateTime date) {
    return DateFormat('dd MMMM, yyyy').format(date);
  }

  // static String formatFullMonthDate(DateTime date) {
  //   return DateFormat('HH:mm').format(date);
  // }


  static String dateMountFormat(DateTime date) {
    return DateFormat('dd MMM ').format(date);
  }
  static String formatDateTime(DateTime dateTime) {
    // Example: 16 Sep 2025, 06:30 PM
    return DateFormat("dd MMM yyyy, hh:mm a").format(dateTime.toLocal());
  }

  static String timeFormat(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static timeWithAMPM(String time) {
    DateTime parsedTime = DateFormat('HH:mm:ss').parse(time);
    String formattedTime = DateFormat('h:mm a').format(parsedTime);
    return formattedTime;
  }

  static timeAgo(DateTime dateTime) {
    final Duration difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} sec${difference.inSeconds == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} Hr${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else {
      final int months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    }
  }

/* static Future<void> isFutureDate(String input) async {
    try {
      DateTime date = DateTime.parse(input);
      DateTime now = DateTime.now();
      await PrefsHelper.setBool(AppConstants.isFutureDate, date.isAfter(now));
    } catch (e) {
      PrefsHelper.setBool(AppConstants.isFutureDate, false);
    }
  }*/
}