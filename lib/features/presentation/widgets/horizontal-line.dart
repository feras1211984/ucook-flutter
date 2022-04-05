import 'package:flutter/material.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';

class HorizontalOrLine extends StatelessWidget {
  const HorizontalOrLine({
    required this.label,
    required this.height,
  });

  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 10.0, right: 15.0),
            child: Divider(
              color: ColorHelper().colorFromHex("#354449"),
              height: height,
              thickness: 2,
            )),
      ),
      Text(
        getLang(context, label) ?? '',
        style: Theme.of(context).textTheme.headline6,
        softWrap: true,
      ),
      Expanded(
        child: new Container(
            margin: const EdgeInsets.only(left: 15.0, right: 10.0),
            child: Divider(
              color: ColorHelper().colorFromHex("#354449"),
              height: height,
              thickness: 2,
            )),
      ),
    ]);
  }
}
