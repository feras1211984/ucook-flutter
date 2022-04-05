import 'package:flutter/material.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';
import 'package:ucookfrontend/features/presentation/widgets/app_bar_widget.dart';
import 'package:ucookfrontend/features/presentation/widgets/drawer_widget.dart';

class WaitingForRegister extends StatefulWidget {
  WaitingForRegister({Key? key}) : super(key: key);

  @override
  _WaitingForRegisterState createState() => _WaitingForRegisterState();
}

class _WaitingForRegisterState extends State<WaitingForRegister> {
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(child: _buildBody(context)),
      // bottomNavigationBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(81),
      //   child: SafeArea(
      //     bottom: true,
      //     child: BottomBar(showBottomBarItems: false),
      //   ),
      // )
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 50.0, bottom: 0),
          child: Center(
            child: Container(
                width: 300,
                height: 40,
                child: Text(
                  getLang(context, "registration-widget-signup-title") ?? '',
                  style: TextStyle(
                      color: ColorHelper().colorFromHex("#354449"),
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: _waitingImage(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: _waitingText(),
        ),
      ],
    );
  }

  Widget _waitingImage() {
    return Image(
      image: AssetImage('images/appicon.png'),
    );
  }

  Widget _waitingText() {
    return Center(
      child: Text(
        getLang(context, 'registration-widget-register-waiting-txt') ?? '',
        style: TextStyle(
            color: ColorHelper().colorFromHex("#354449"),
            fontSize: 20,
            fontWeight: FontWeight.w500),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );
  }
}
