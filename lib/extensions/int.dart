import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';

extension CustomInt on int {
  String timestampMilli() {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      this * 1000,
      isUtc: true,
    );

    return timeago.format(dateTime);
  }

  String humanCompact() {
    return NumberFormat().format(this);
  }
}
