import 'package:intl/intl.dart';

class DateHelper {
  static String toFormattedDateWithTime(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    String formattedDate =
        DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String toFormattedDateWithDayName(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm").parse(date, true).toLocal();
    String formattedDate =
        DateFormat('EEEE, dd MMMM yyyy HH:mm', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String toFormattedDate(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    String formattedDate =
        DateFormat('dd MMMM yyyy', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String toFormattedDateNumber(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    String formattedDate = DateFormat('yyyy-MM-dd', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String fromDateToFormatted(DateTime date) {
    String formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    return formattedDate;
  }

  static String fromDateWithTimeToFormatted(DateTime date) {
    String formattedDate = DateFormat(
      'yyyy-MM-ddTHH:mm:ss',
    ).format(date);
    return formattedDate;
  }

  static DateTime toDateTime(String date) {
    DateTime parsedDate = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true);
    return parsedDate;
  }

  static String toFormatDurationTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  static String toFormattedMonthYear(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    String formattedDate = DateFormat('MMMM yyyy', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String toFormattedDateWithoutTime(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    String formattedDate = DateFormat('dd-MM-yyyy', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String getDay(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    String formattedDate = DateFormat('dd', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String getMonth(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    String formattedDate = DateFormat('MMM', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String getMonthFull(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    String formattedDate = DateFormat('MMMM', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String getMonthNumber(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    String formattedDate = DateFormat('MM', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String getYear(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    String formattedDate = DateFormat('yyyy', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String getTime(String date, [bool utc = true]) {
    if (!utc) {
      DateTime parsedDate =
          DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, false);
      String formattedDate = DateFormat('HH:mm', 'id_ID').format(parsedDate);
      return formattedDate;
    }
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    String formattedDate = DateFormat('HH:mm', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String getTimeWithSecond(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    String formattedDate = DateFormat('HH:mm:ss', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static bool compareDateMoreThanDay(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    Duration diff = DateTime.now().difference(parsedDate);
    if (diff.inDays > 0) {
      return true;
    }
    return false;
  }

  static String toFormattedDateSortMonth(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    String formattedDate =
        DateFormat('dd MMM yyyy', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String toFormattedShortDateWithTime(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    String formattedDate =
        DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String toFormattedDateFromEpoch(int epoch) {
    return DateTime.fromMicrosecondsSinceEpoch(epoch).toIso8601String();
  }

  static String getDateAndMonth(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm:ss").parse(date, true).toLocal();
    String formattedDate = DateFormat('dd MMM', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String getDayName(String date) {
    DateTime parsedDate =
        DateFormat("yyyy-MM-ddTHH:mm").parse(date, true).toLocal();
    String formattedDate = DateFormat('EEEE, ', 'id_ID').format(parsedDate);
    return formattedDate;
  }

  static String formatDateWithOnlineStatus(int seconds) {
    final duration = Duration(seconds: seconds);
    if (duration.inDays >= 90) {
      return 'Tidak aktif';
    } else if (duration.inDays >= 30) {
      return 'Aktif lebih dari sebulan yang lalu';
    } else if (duration.inDays >= 14) {
      return 'Aktif 2 minggu yang lalu';
    } else if (duration.inDays >= 7) {
      return 'Aktif lebih dari seminggu yang lalu';
    } else if (duration.inDays >= 1) {
      return 'Aktif ${duration.inDays} hari yang lalu';
    } else if (duration.inHours >= 1) {
      return 'Aktif ${duration.inHours} jam yang lalu';
    } else if (duration.inMinutes >= 5) {
      return 'Aktif ${duration.inMinutes} menit yang lalu';
    } else {
      return 'Sedang aktif';
    }
  }

  static String formatDateWithBasicTime(String date) {
    DateTime parsedDate = DateTime.parse(date).toLocal();
    Duration difference = DateTime.now().difference(parsedDate);
    if (difference.inDays < 1) {
      return getTime(date);
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else {
      return toFormattedDate(date);
    }
  }
}
