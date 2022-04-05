import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/notifications/notifications_bloc.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/features/presentation/utils/routes.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';
import 'package:ucookfrontend/features/presentation/widgets/cart_quantity_badge.dart';
import '../../../shared_variables_and_methods.dart';
import '../bloc/notifications/notifications_states.dart';
import 'notifications_quantity_badge_content.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar(
      {required this.showCart,
      required this.showSearch,
      required this.showBackButton});

  final bool showCart;
  final bool showSearch;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    if (showSearch)
      return AppBar(
        toolbarHeight: 50,
        automaticallyImplyLeading: false,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 28,
                  color: Colors.black,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, ARTICLE_SEARCH);
                  },
                  child: Container(
                    width: SharedController().scaledWidth(context, 150),
                    child: Text(
                      getLang(context, "app-bar-search-hint") ?? '',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0,
                        fontFamily: "Bahnschrift",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))
            ],
          ),
        ),
        actions: <Widget>[
          BlocBuilder<NotificationsBloc, NotificationsState>(
            bloc: notificationsBloc,
            builder: (context, state) {
              int unopenedNotificationsCount = getUnopenedNotificationsCount();
              return Badge(
                showBadge: unopenedNotificationsCount > 0,
                position: const BadgePosition(
                  top: 0,
                  end: 35,
                ),
                animationType: BadgeAnimationType.scale,
                badgeContent: NotificationsQuantityBadgeContent(
                    unopenedNotificationsCount: unopenedNotificationsCount),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, NOTIFICATIONS_ROUTE);
                  },
                  icon: Icon(
                    Icons.notifications,
                    size: 28,
                    color: Colors.black,
                  ),
                ),
                badgeColor: Colors.red,
              );
            },
          ),
          if (showCart)
            SizedBox(
              width: 10,
            ),
          if (showCart)
            Badge(
              position: const BadgePosition(
                top: 0,
                end: 40,
              ),
              animationType: BadgeAnimationType.scale,
              badgeContent: CartQuantityBadge(),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, CART_ROUTE);
                },
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  size: 28,
                  color: Colors.black,
                ),
              ),
              badgeColor: Colors.white,
            ),
          if (showBackButton)
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new),
              iconSize: 20.0,
              onPressed: () {
                _goBack(context);
              },
            )
        ],
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      );
    else
      return AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 28,
                  color: Colors.black,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
      );
  }

  _goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
