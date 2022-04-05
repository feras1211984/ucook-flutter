import '../../../data/models/notification.dart';

abstract class NotificationsEvent {}

class NotificationReceived extends NotificationsEvent {
  final Notification notification;
  NotificationReceived({required this.notification});
}

class DeleteNotification extends NotificationsEvent {
  final Notification notification;
  DeleteNotification({required this.notification});
}

class OpenNotification extends NotificationsEvent {
  final Notification notification;
  OpenNotification({required this.notification});
}

class GetNotifications extends NotificationsEvent {}
