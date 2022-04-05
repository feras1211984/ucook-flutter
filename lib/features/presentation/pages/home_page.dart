import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:rolling_nav_bar/rolling_nav_bar.dart';
import 'package:ucookfrontend/features/presentation/pages/article_category_page.dart';
import 'package:ucookfrontend/features/presentation/pages/setting_page.dart';
import 'package:ucookfrontend/features/presentation/utils/Pair.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';
import 'package:ucookfrontend/features/presentation/widgets/app_bar_widget.dart';
import 'package:ucookfrontend/features/presentation/widgets/drawer_widget.dart';
import '../../../core/firebase/firebase_cloud_messaging_service.dart';
import '../../../shared_variables_and_methods.dart';
import '../bloc/notifications/notifications_events.dart';
import 'orders_page.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  Widget? _articleCategories;
  Widget? _orders;
  Widget? _settings;
  int _selectedIndex = 1;
  late final List<Widget Function()> componentsBuilders;

  late final List<Pair<int, Widget>> pushedWidgets = [];
  late Color logoColor;

  late var iconText;
  var iconData = <IconData>[
    Icons.file_copy_outlined,
    Icons.home,
    Icons.settings,
  ];
  var badges = <int>[
    0,
    0,
    0,
  ];

  var indicatorColors = <Color>[
    ColorHelper().colorFromHex('#989cb8'),
    ColorHelper().colorFromHex('#989cb8'),
    ColorHelper().colorFromHex('#989cb8'),
  ];

  @override
  void initState() {
    initializeFirebaseCloudMessagingService();
    notificationsBloc.add(GetNotifications());
    componentsBuilders = [
      () {
        if (_orders == null) {
          _orders = OrderPage();
        }
        return _orders!;
      },
      () {
        if (_articleCategories == null) {
          _articleCategories = ArticleCategoriesPage();
        }
        return _articleCategories!;
      },
      () {
        if (_settings == null) {
          _settings = SettingPage();
        }
        return _settings!;
      }
    ];
    pushedWidgets.add(Pair(1, componentsBuilders[1]()));
  }

  @override
  Widget build(BuildContext context) {
    iconText = <Widget>[
      Text(getLang(context, "buttom-bar-widget-orders") ?? '',
          style: TextStyle(color: Colors.grey, fontSize: 12)),
      Text(getLang(context, "buttom-bar-widget-home") ?? '',
          style: TextStyle(color: Colors.grey, fontSize: 12)),
      Text(getLang(context, "buttom-bar-widget-settings") ?? '',
          style: TextStyle(color: Colors.grey, fontSize: 12)),
    ];
    return FGBGNotifier(
      onEvent: (FGBGType event) {
        if (event == FGBGType.foreground) {
          notificationsBloc.add(GetNotifications());
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        drawer: DrawerWidget(),
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(SharedController().scaledHeight(context, 60)),
          child: CustomAppBar(
            showSearch: true,
            showCart: true,
            showBackButton: false,
          ),
        ),
        backgroundColor: Colors.white,
        bottomNavigationBar: _buildBottomNavigationBar(),
        body: DoubleBackToCloseApp(
            snackBar: SnackBar(
              content:
                  Text(getLang(context, "home-page-exit-app-message") ?? ''),
            ),
            child: componentsBuilders[pushedWidgets.last.key]()),
      ),
    );
  }

  void incrementIndex() {
    setState(() {
      _selectedIndex =
          _selectedIndex < (iconData.length - 1) ? _selectedIndex + 1 : 0;
    });
  }

  _onAnimate(AnimationUpdate update) {
    setState(() {
      logoColor = update.color;
    });
  }

  _onTap(int index) {
    if (_selectedIndex == index) {
      _incrementBadge();
    }
    _selectedIndex = index;
    setState(() {});
  }

  void _incrementBadge() {
    badges[_selectedIndex] =
        badges[_selectedIndex] == null ? 1 : badges[_selectedIndex] + 1;
    setState(() {});
  }

  Widget _buildBottomNavigationBar() {
    double largeIconHeight = MediaQuery.of(context).size.width;
    double navBarHeight = SharedController().scaledHeight(context, 70);
    double topOffset = (MediaQuery.of(context).size.height -
            largeIconHeight -
            MediaQuery.of(context).viewInsets.top -
            (navBarHeight * 2)) /
        2;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      height: navBarHeight,
      width: MediaQuery.of(context).size.width,
      child: RollingNavBar.iconData(
        activeBadgeColors: <Color>[
          Colors.white,
        ],
        activeIndex: _selectedIndex,
        animationCurve: Curves.linear,
        animationType: AnimationType.roll,
        baseAnimationSpeed: 200,
        iconData: iconData,
        iconColors: <Color>[Colors.black],
        iconText: iconText,
        indicatorColors: indicatorColors,
        iconSize: 36,
        indicatorRadius: SharedController().scaledHeight(context, 33),
        onAnimate: _onAnimate,
        onTap: _handleNavigation,
      ),
    );
  }

  void _handleNavigation(index) {
    setState(() {
      pushedWidgets.add(Pair(index, componentsBuilders[index]()));
    });
  }
}
