import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared_variables_and_methods.dart';
import '../bloc/notifications/notifications_bloc.dart';
import '../bloc/notifications/notifications_events.dart';
import '../bloc/notifications/notifications_states.dart';
import '../utils/localiztion/applocal.dart';
import '../utils/routes.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    notificationsBloc.add(GetNotifications());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.grey,
          title: Text(
            getLang(
              context,
              'notifications-page-title',
            ),
            style: const TextStyle(
              fontSize: 25,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new),
              iconSize: 20.0,
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: BlocBuilder<NotificationsBloc, NotificationsState>(
          bloc: notificationsBloc,
          builder: (context, state) {
            return state is NotificationsAreLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (BuildContext context, int index) {
                      var notification = notifications[index];
                      return Dismissible(
                        onDismissed: (direction) {
                          notificationsBloc.add(
                              DeleteNotification(notification: notification));
                        },
                        confirmDismiss: (direction) async {
                          return await showDeleteNotificationDialog(context);
                        },
                        key: Key('$index'),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            right: 10,
                            left: 10,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black54,
                                width: 3,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  20,
                                ),
                              ),
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  NOTIFICATION_ROUTE,
                                  arguments: notification,
                                );
                                notificationsBloc.add(OpenNotification(
                                    notification: notification));
                              },
                              title: Text(
                                notification.title,
                                style: TextStyle(
                                  color: notification.opened
                                      ? Colors.black54
                                      : Colors.black,
                                  fontSize: 25,
                                ),
                              ),
                              subtitle: Text(
                                dateFormatter.format(
                                  notification.time,
                                ),
                                style: TextStyle(
                                  color: notification.opened
                                      ? Colors.black54
                                      : Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                              leading: CircleAvatar(
                                foregroundImage: CachedNetworkImageProvider(
                                  notification.imageUrl ?? "",
                                ),
                                backgroundImage: const AssetImage(
                                  "images/notification.png",
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.black54,
                                  size: 30,
                                ),
                                onPressed: () async {
                                  if (await showDeleteNotificationDialog(
                                      context)) {
                                    notificationsBloc.add(DeleteNotification(
                                        notification: notification));
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    });
          },
        ),
      ),
    );
  }
}

Future<bool> showDeleteNotificationDialog(BuildContext context) async {
  return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text(
              getLang(
                context,
                'notifications-page-confirm-remove-notification-title',
              ),
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            content: SingleChildScrollView(
              child: Text(
                getLang(
                  context,
                  'notifications-page-confirm-remove-notification-msg',
                ),
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pop(true);
                },
                child: Text(
                  getLang(
                    context,
                    'yes',
                  ),
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontSize: 20,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).pop(false);
                },
                child: Text(
                  getLang(
                    context,
                    'no',
                  ),
                  style: const TextStyle(
                    color: Colors.indigo,
                    fontSize: 20,
                  ),
                ),
              ),
            ]);
      });
}
