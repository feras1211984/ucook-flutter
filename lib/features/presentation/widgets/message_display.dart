import 'package:flutter/material.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';

import 'app_bar_widget.dart';
import 'drawer_widget.dart';

class MessageDisplay extends StatelessWidget {
  final String message;
  final bool withScaffold;

  const MessageDisplay({
    Key? key,
    required this.message,
    required this.withScaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (withScaffold) {
      return Scaffold(
        backgroundColor: Colors.white,
        drawer: DrawerWidget(),
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(SharedController().scaledHeight(context, 60)),
          child: CustomAppBar(
            showCart: false,
            showSearch: false,
            showBackButton: false,
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height / 3,
          child: Center(
            child: SingleChildScrollView(
              child: Text(
                message,
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Center(
          child: SingleChildScrollView(
            child: Text(
              message,
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
  }
}
