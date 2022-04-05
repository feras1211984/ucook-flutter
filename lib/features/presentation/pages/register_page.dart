import 'package:country_codes/country_codes.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/userManager/user_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/userManager/user_event.dart';
import 'package:ucookfrontend/features/presentation/bloc/userManager/user_state.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/features/presentation/utils/routes.dart';
import 'package:ucookfrontend/features/presentation/widgets/app_bar_widget.dart';
import 'package:ucookfrontend/features/presentation/widgets/drawer_widget.dart';
import 'package:ucookfrontend/injection_container.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String code = "";
  final nameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  CountryDetails details = CountryCodes.detailsForLocale();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: DrawerWidget(),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: CustomAppBar(
          showSearch: false,
          showCart: false,
          showBackButton: false,
        ),
      ),
      body: SingleChildScrollView(child: _buildBody(context)),
    );
  }

  BlocProvider<MobileUserBloc> _buildBody(BuildContext context) {
    return BlocProvider(
        create: (_) => sl<MobileUserBloc>(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _appLogo(),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: _nameEditText(),
            ),
            Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                child: Directionality(
                    textDirection: TextDirection.ltr, child: _countryPicker())),
            Padding(
              padding: EdgeInsets.only(left: 100, right: 100, top: 25),
              child: _signupButton(context),
            ),
          ],
        ));
  }

  Widget _nameEditText() {
    return TextFormField(
      style: TextStyle(fontSize: 16),
      controller: nameController,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: BorderSide(
                color: ColorHelper().materialColorFromHex("#989cb8"),
                width: 5)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(35),
            borderSide: BorderSide(
                color: ColorHelper().materialColorFromHex("#989cb8"),
                width: 5)),
        hintText: getLang(context, "registration-widget-name"),
      ),
    );
  }

  Widget _countryPicker() {
    CountryDetails details = CountryCodes.detailsForLocale();
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

  BlocConsumer<MobileUserBloc, UserState> _signupButton(BuildContext context) {
    return BlocConsumer(
      listener: (BuildContext context, UserState state) {
        if (state is NewUser) {
          Navigator.popAndPushNamed(context, CONFIRM_VERIFICATION_CODE_ROUTE,
              arguments: this.code + mobileNumberController.text);
        } else if (state is NotApprovedUser) {
          Navigator.popAndPushNamed(context, CONFIRM_VERIFICATION_CODE_ROUTE,
              arguments: this.code + mobileNumberController.text);
        } else if (state is LoggedIn) {
          Navigator.popAndPushNamed(context, CONFIRM_VERIFICATION_CODE_ROUTE,
              arguments: this.code + mobileNumberController.text);
        } else if (state is BlockedUser) {
          AlertDialog(
              title: Text(
                  getLang(context, "registration-widget-blocked-user-alert") ??
                      ''));
        } else if (state is Error) {
          print('error');
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
              if (!(state is SigningUpState)) {
                BlocProvider.of<MobileUserBloc>(context).add(RegisterUser(
                    nameController.text, code + mobileNumberController.text));
              }
            },
            child: state is SigningUpState
                ? SizedBox(
                    width: 16.0,
                    height: 16.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    getLang(context, "registration-widget-signup-btn") ?? ''),
          ),
        );
      },
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
