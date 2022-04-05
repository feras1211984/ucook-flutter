import 'package:firebase_messaging/firebase_messaging.dart';

class Notification {
  String? id;
  late DateTime time;
  late String title;
  late String details;
  String? imageUrl;
  late bool opened;

  Notification(
      {required this.id,
        required this.time,
        required this.title,
        required this.details,
        required this.imageUrl,
        required this.opened});
  Notification.fromMap(Map<String, dynamic> notificationMap) {
    id = notificationMap["id"];
    time = DateTime.fromMillisecondsSinceEpoch(notificationMap["time"]);
    title = notificationMap["title"];
    details = notificationMap["details"];
    imageUrl = notificationMap["image_url"];
    opened = notificationMap["opened"] == 1;
  }
  Notification.fromMessage(RemoteMessage message) {
    id = message.messageId;
    time = message.sentTime ?? DateTime.now();
    title = message.notification?.title ?? "";
    details = message.notification?.body ?? "";

    if (message.notification?.android != null) {
      imageUrl = message.notification?.android?.imageUrl;
    }
    if (message.notification?.apple != null) {
      imageUrl = message.notification?.apple?.imageUrl;
    }
    opened = false;
  }
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "time": time.millisecondsSinceEpoch,
      "title": title,
      "details": details,
      "image_url": imageUrl,
      "opened": opened == true ? 1 : 0
    };
  }
}
