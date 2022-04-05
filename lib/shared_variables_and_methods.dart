import 'package:intl/intl.dart';
import 'features/data/models/notification.dart';
import 'features/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:flutter/material.dart' as material;

List<Notification> notifications = [];
final NotificationsBloc notificationsBloc = NotificationsBloc();
final DateFormat dateFormatter = DateFormat('d-M-yyyy h:m:s a');
final material.GlobalKey<material.NavigatorState> navigator =
    material.GlobalKey<material.NavigatorState>();
int getUnopenedNotificationsCount() {
  return notifications
      .where((Notification notification) => !notification.opened)
      .length;
}
