import 'package:flutter/material.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';

import 'app_bar_widget.dart';
import 'drawer_widget.dart';

class LoadingWidget extends StatelessWidget {
  final bool withScaffold;

  const LoadingWidget({Key? key, required this.withScaffold}) : super(key: key);

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
          height: MediaQuery.of(context).size.height * 0.4,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
