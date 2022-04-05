import 'package:flutter/material.dart';
import 'package:rolling_nav_bar/rolling_nav_bar.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';

class BottomBar extends StatefulWidget {
  BottomBar({required this.showBottomBarItems});

  final bool showBottomBarItems;

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with TickerProviderStateMixin {
  int _selectedIndex = 1;
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
    Colors.red,
    Colors.orange,
    Colors.green,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    double largeIconHeight = MediaQuery.of(context).size.width;
    double navBarHeight = SharedController().scaledHeight(context, 70);
    double topOffset = (MediaQuery.of(context).size.height -
            largeIconHeight -
            MediaQuery.of(context).viewInsets.top -
            (navBarHeight * 2)) /
        2;
    iconText = <Widget>[
      Text(getLang(context, "buttom-bar-widget-orders") ?? '',
          style: TextStyle(color: Colors.grey, fontSize: 12)),
      Text(getLang(context, "buttom-bar-widget-home") ?? '',
          style: TextStyle(color: Colors.grey, fontSize: 12)),
      Text(getLang(context, "buttom-bar-widget-settings") ?? '',
          style: TextStyle(color: Colors.grey, fontSize: 12)),
    ];
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
      // Option 1: Recommended
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
        iconSize: 28,
        indicatorRadius: SharedController().scaledHeight(context, 33),
        onAnimate: _onAnimate,
        onTap: _onTap,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }
}
