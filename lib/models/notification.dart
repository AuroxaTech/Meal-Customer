import 'package:intl/intl.dart';

class NotificationModel {
  int? index;
  String? title;
  String? body;
  String? image;
  int? timeStamp;
  bool read;

  NotificationModel({
    this.index,
    this.title,
    this.body,
    this.timeStamp,
    this.image,
    this.read = false,
  });

  String get formattedTimeStamp {
    final notificationDateTime = DateTime.fromMillisecondsSinceEpoch(
      this.timeStamp ?? DateTime.now().millisecondsSinceEpoch,
    );
    final formattedDate = DateFormat("EEE dd, MMM yyyy").format(
      notificationDateTime,
    );
    return "$formattedDate";
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    "image": image,
    'timeStamp': timeStamp,
    'read': read,
  };
}
