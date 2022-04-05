import 'package:flutter/material.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';

class NotificationsQuantityBadgeContent extends StatelessWidget {
  const NotificationsQuantityBadgeContent(
      {Key? key, required this.unopenedNotificationsCount})
      : super(key: key);
  final int unopenedNotificationsCount;
  @override
  Widget build(BuildContext context) {
    return Text(
      unopenedNotificationsCount.toString(),
      style: TextStyle(
        fontSize: SharedController().getAdaptiveTextSize(context, 15),
        fontFamily: "Bahnschrift",
        color: Colors.black,
      ),
    );
  }
}
