import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:ucookfrontend/features/presentation/bloc/verificationcode/vcode_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/verificationcode/vcode_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/verificationcode/vcode_state.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/features/presentation/utils/routes.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';
import 'package:ucookfrontend/features/presentation/widgets/drawer_widget.dart';

class VerificationCodePage extends StatefulWidget {
  VerificationCodePage({required this.phone});
  final String phone;
  @override
  _VerificationCodeState createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCodePage> {
  final mobileNumberController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<VerificationCodeBloc>(context)
        .add(SendVerificationCodeEvent(widget.phone));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerWidget(),
      body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            content: Text(getLang(context, "home-page-exit-app-message") ?? ''),
          ),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.only(
                top: SharedController().scaledHeight(context, 60)),
            child: _buildBody(context),
          ))),
    );
  }

  BlocConsumer<VerificationCodeBloc, VCodeStates> _buildBody(
      BuildContext context) {
    return BlocConsumer(listener: (BuildContext context, VCodeStates state) {
      if (state is WrongVCodeState) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                title: Text(getLang(context, "rev-code-page-wrong") ?? '')));
      } else if (state is RightVCodeState) {
        Navigator.popAndPushNamed(context, HOME_ROUTE);
      }
    }, builder: (BuildContext context, VCodeStates state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _appLogo(),
          phoneTxt(),
          _vCodeEditText(context),
          resendCodeBtn(),
          correctPhoneBtn(),
        ],
      );
    });
  }

  Widget _vCodeEditText(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          width: SharedController().scaledWidth(context, 300),
          child: Center(
            child: Text(
              getLang(context, "rev-code-page-enter-code") ?? '',
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Directionality(
          textDirection: TextDirection.ltr,
          child: VerificationCode(
            textStyle: TextStyle(fontSize: 20.0, color: Colors.red[900]),
            keyboardType: TextInputType.number,
            underlineColor: Colors.amber,
            autofocus: true,
            length: 4,
            onCompleted: (String value) {
              BlocProvider.of<VerificationCodeBloc>(context)
                  .add(CheckVerificationCodeEvent(int.parse(value)));
            },
            onEditing: (bool value) {},
          ),
        ),
      ],
    );
  }

  Widget resendCodeBtn() {
    return TextButton(
      onPressed: () {
        BlocProvider.of<VerificationCodeBloc>(context)
            .add(SendVerificationCodeEvent(widget.phone));
      },
      child: Text(
        getLang(context, "rev-code-page-resend-code") ?? '',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }

  Widget phoneTxt() {
    return Text(
      (getLang(context, "rev-code-page-phone") ?? '') +
          widget.phone.replaceFirst(RegExp(r'\+'), ''),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.subtitle2,
    );
  }

  Widget correctPhoneBtn() {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: TextButton(
        onPressed: () {
          Navigator.popAndPushNamed(context, LOGIN_ROUTE);
        },
        child: Text(
          getLang(context, "rev-code-page-correct-phone") ?? '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headline5,
        ),
      ),
    );
  }

  Widget _appLogo() {
    return Container(
        height: 300, child: Image(image: AssetImage('images/appicon.png')));
  }
}
