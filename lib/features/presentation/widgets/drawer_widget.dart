import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ucookfrontend/features/data/datasources/Cash/cash_auth_data_source.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/features/presentation/utils/routes.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';
import 'package:ucookfrontend/injection_container.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/firebase/firebase_cloud_messaging_service.dart';

class DrawerWidget extends StatelessWidget {
  static TokenCashDataSourceImpl _tokenCashDataSourceImpl = sl();

  DrawerWidget();
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      DrawerHeader(
        decoration: BoxDecoration(
            color: ColorHelper().colorFromHex('354449'),
            image: DecorationImage(image: AssetImage('images/logo@2x.png'))),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            getLang(context, "drawer-widget-drawer-header") ?? '',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      // ListTile(
      //   title: Text('Courses'),
      //   onTap: () {
      //     Navigator.pop(context);
      //     Navigator.pushNamed(context, COURSES_ROUTE);
      //   },
      // ),
      if (_tokenCashDataSourceImpl.getTokenAsString().isEmpty)
        ListTile(
          title: Text(getLang(context, "drawer-widget-login-page") ?? ''),
          onTap: () {
            Navigator.popAndPushNamed(context, LOGIN_ROUTE);
          },
        ),
      if (_tokenCashDataSourceImpl.getTokenAsString().isEmpty)
        ListTile(
          title: Text(getLang(context, "drawer-widget-signup-page") ?? ''),
          onTap: () {
            Navigator.popAndPushNamed(context, REGISTER_ROUTE);
          },
        ),
      if (_tokenCashDataSourceImpl.getTokenAsString().isNotEmpty)
        ListTile(
          title: Text(getLang(context, "drawer-widget-logout") ?? ''),
          onTap: () {
            _tokenCashDataSourceImpl.deleteToken();
            firebaseMessaging.unsubscribeFromTopic('ucook');
            Navigator.popAndPushNamed(context, LOGIN_ROUTE);
          },
        ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getLang(context, "drawer-widget-owner-info") ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: SharedController().colorFromHex('#354449'),
                        fontSize:
                            SharedController().getAdaptiveTextSize(context, 16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'www.alkhazensoft.net',
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () {
                            launch('https://www.alkhazensoft.net');
                          },
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          color: SharedController().colorFromHex('#354449'),
                          fontSize: SharedController()
                              .getAdaptiveTextSize(context, 16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    ]));
  }
}
