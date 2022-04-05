import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/main.dart';

import '../../../injection_container.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  SharedPreferences mySharedPref = sl();
  String dropdownValue =
      mySharedPreferences.getString("lang") == 'en' ? 'English' : 'عربي';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 145),
              child: Text(getLang(context, "setting-page-lang-label") ?? '',
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 145),
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_drop_down_circle),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: ColorHelper().colorFromHex("#989cb8")),
                underline: Container(
                  height: 2,
                  color: ColorHelper().colorFromHex("#989cb8"),
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    // dropdownValue = newValue!;
                    _confirmChangeLang(newValue!);
                  });
                },
                items: <String>['عربي', 'English']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ],
    );
  }

  Future<bool> _confirmChangeLang(String newlang) async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text(getLang(context, "home-page-exit-app-title") ?? ''),
            content: new Text(
                getLang(context, "setting-page-change-lang-message") ?? ''),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  return Navigator.of(context).pop(false);
                },
                child: new Text(getLang(context, "no") ?? ''),
              ),
              TextButton(
                onPressed: () {
                  if (newlang == 'عربي') {
                    mySharedPreferences.setString("lang", 'ar');
                  } else {
                    mySharedPreferences.setString("lang", 'en');
                  }
                  Restart.restartApp();
                },
                child: new Text(getLang(context, "yes") ?? ''),
              ),
            ],
          ),
        )) ??
        false;
  }
}
