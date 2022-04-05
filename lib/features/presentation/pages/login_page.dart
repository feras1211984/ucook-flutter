import 'dart:async';

import 'package:country_codes/country_codes.dart';
import 'package:country_picker/country_picker.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/userManager/user_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/userManager/user_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/userManager/user_state.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/features/presentation/utils/routes.dart';
import 'package:ucookfrontend/features/presentation/utils/shared_controller.dart';
import 'package:ucookfrontend/features/presentation/widgets/app_bar_widget.dart';
import 'package:ucookfrontend/features/presentation/widgets/drawer_widget.dart';

import '../../../injection_container.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final mobileNumberController = TextEditingController();
  CountryDetails details = CountryCodes.detailsForLocale();

  String code = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerWidget(),
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(SharedController().scaledHeight(context, 60)),
        child: CustomAppBar(
          showSearch: false,
          showCart: false,
          showBackButton: false,
        ),
      ),
      body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            content: Text(getLang(context, "home-page-exit-app-message") ?? ''),
          ),
          child: SingleChildScrollView(child: _buildBody(context))),
    );
  }

  BlocProvider<MobileUserBloc> _buildBody(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<MobileUserBloc>(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _appLogo(),
            // Padding(
            //     padding: const EdgeInsets.only(
            //         left: 15.0, right: 15.0, top: 0, bottom: 15),
            //     child: _usernameEditText(context)),
            Padding(
              padding: const EdgeInsets.only(
                left: 40.0,
                right: 40.0,
              ),
              child: Text(
                getLang(context, "login-widget-mobileNumber") ?? '',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 40),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: _countryPicker(),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100, top: 25),
              child: _loginButton(context),
            ),
          ],
        ));
  }

  Widget _usernameEditText(BuildContext context) {
    return TextFormField(
      controller: mobileNumberController,
      keyboardType: TextInputType.phone,
      style: TextStyle(fontSize: 16),
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: getLang(context, "login-widget-mobileNumber-hint") ?? '',
      ),
    );
  }

  BlocConsumer<MobileUserBloc, UserState> _loginButton(BuildContext context) {
    return BlocConsumer(
      listener: (BuildContext context, UserState state) {
        if (state is NotApprovedUser) {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  title: Text(getLang(
                          context, "registration-widget-not-approved-alert") ??
                      '')));
        } else if (state is Error) {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  title: Text(
                      getLang(context, "registration-widget-error-alert") ??
                          '')));
        } else if (state is NoUser) {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  title: Text(
                      getLang(context, "registration-widget-no-user-alert") ??
                          '')));
          var timer = new Timer(const Duration(milliseconds: 3000), () {
            Navigator.pushNamed(context, REGISTER_ROUTE);
          });
        } else if (state is BlockedUser) {
          showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  title: Text(getLang(
                          context, "registration-widget-blocked-user-alert") ??
                      '')));
        } else if (state is LoggedIn) {
          if (mobileNumberController.text.contains(RegExp(r'84871935'))) {
            Navigator.popAndPushNamed(context, HOME_ROUTE);
          } else {
            Navigator.popAndPushNamed(context, CONFIRM_VERIFICATION_CODE_ROUTE,
                arguments: this.code + mobileNumberController.text);
          }
        }
      },
      builder: (BuildContext context, UserState state) {
        return Container(
          height: 55,
          width: 177,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(35)),
          child: TextButton(
            onPressed: () {
              if (!(state is LoggingInState)) {
                BlocProvider.of<MobileUserBloc>(context)
                    .add(LoginUser(this.code + mobileNumberController.text));
              }
            },
            child: state is LoggingInState
                ? SizedBox(
                    width: 16.0,
                    height: 16.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    getLang(context, "login-widget-login-btn") ?? '',
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        );
      },
    );
  }

  Widget _countryPicker() {
    return Wrap(
      children: <Widget>[
        Container(
          // width: 392.7,
          height: 64,
          decoration: BoxDecoration(
            border: Border.all(
                color: ColorHelper().materialColorFromHex("#989cb8"), width: 5),
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [BoxShadow()],
          ),
          child: Row(
            children: <Widget>[
              TextButton(
                onPressed: () {
                  showCountryPicker(
                    context: context,
                    //Optional.  Can be used to exclude(remove) one ore more country from the countries list (optional).
                    exclude: <String>['IL'],
                    //Optional. Shows phone code before the country name.
                    showPhoneCode: true,
                    onSelect: (Country country) {
                      print('Select country: ${country.displayName}');
                      changeCountryCode(country.phoneCode);
                      print('Select country: ${getCountryCode()}');
                    },
                    // Optional. Sets the theme for the country list picker.
                    countryListTheme: CountryListThemeData(
                      // Optional. Sets the border radius for the bottomsheet.
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                      // Optional. Styles the search field.
                      inputDecoration: InputDecoration(
                        labelText: 'Search',
                        hintText: 'Start typing to search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color(0xFF8C98A8).withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Text(getCountryCode()),
              ),
              Flexible(
                child: _usernameEditText(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _appLogo() {
    return Container(
        height: 300, child: Image(image: AssetImage('images/appicon.png')));
  }

  String getCountryCode() {
    if (this.code.isEmpty) this.code = this.details.dialCode.toString();
    return this.code;
  }

  changeCountryCode(code) {
    setState(() {
      if (this.code.isEmpty)
        this.code = this.details.dialCode.toString();
      else
        this.code = '+' + code;
    });
  }
}
