// @dart=2.9
//2-4-2022
import 'dart:io';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucookfrontend/features/presentation/bloc/cart/cart_bloc.dart';
import 'package:ucookfrontend/features/presentation/bloc/order/order_bloc.dart';
import 'package:ucookfrontend/features/presentation/utils/color_helper.dart';
import 'package:ucookfrontend/features/presentation/utils/localiztion/applocal.dart';
import 'package:ucookfrontend/injection_container.dart';
import 'package:ucookfrontend/shared_variables_and_methods.dart';
import 'features/domain/repositories/mobile_user_repository.dart';
import 'features/presentation/utils/route_generator.dart';
import 'injection_container.dart' as di;
import 'package:provider/provider.dart';

SharedPreferences mySharedPreferences = sl();
MobileUserRepository mobileUserRepository = sl();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CountryCodes.init();
  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await di.init();
  runApp(
    MultiProvider(
      providers: [
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(orderUseCase: sl()),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => OrderBloc(orderUseCase: sl()),
        ),
        ChangeNotifierProvider(
          create: (context) => ChangeLang(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        AppLocale.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("ar", ""),
        Locale("en", ""),
      ],
      localeResolutionCallback: (currentLang, supportLang) {
        if (currentLang != null) {
          for (Locale locale in supportLang) {
            if (locale.languageCode == mySharedPreferences.getString("lang")) {
              return locale;
            }
          }
        }
        return supportLang.first;
      },
      title: 'Ucook',
      theme: ThemeData(
          fontFamily: 'GESS',
          primarySwatch: ColorHelper().materialColorFromHex("#989cb8"),
          primaryColor: ColorHelper().colorFromHex("#354449"),
          dividerColor: ColorHelper().colorFromHex("#354449"),
          splashColor: ColorHelper().colorFromHex("#354449"),
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 34.0,
                fontWeight: FontWeight.bold,
                fontFamily: "Bahnschrift",
                color: ColorHelper().colorFromHex("#354449")),
            headline2: TextStyle(
                fontSize: 24.0,
                fontFamily: "Bahnschrift",
                fontWeight: FontWeight.bold,
                color: ColorHelper().colorFromHex("#354449")),
            headline4: TextStyle(
                fontSize: 14.0,
                fontFamily: "Bahnschrift",
                fontWeight: FontWeight.w500,
                color: ColorHelper().colorFromHex("#354449")),
            headline5: TextStyle(
                fontSize: 20.0,
                fontFamily: "Bahnschrift",
                fontWeight: FontWeight.w500,
                color: ColorHelper().colorFromHex("#354449")),
            headline6: TextStyle(
                fontFamily: "Bahnschrift",
                fontSize: 22.0,
                color: ColorHelper().colorFromHex("#354449")),
            bodyText1: TextStyle(
                fontFamily: "Bahnschrift",
                fontSize: 24.0,
                fontWeight: FontWeight.w500,
                color: ColorHelper().colorFromHex("#354449")),
            bodyText2: TextStyle(
                fontFamily: "Bahnschrift",
                fontSize: 36.0,
                fontWeight: FontWeight.w500,
                color: ColorHelper().colorFromHex("#989cb8")),
            subtitle1: TextStyle(
                fontFamily: "Bahnschrift",
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: ColorHelper().colorFromHex("#354449")),
            subtitle2: TextStyle(
                fontFamily: "Bahnschrift",
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: ColorHelper().colorFromHex("#354449")),
            button: TextStyle(
                fontFamily: "Bahnschrift",
                fontSize: 22.0,
                fontWeight: FontWeight.w500,
                color: Colors.white),
            caption: TextStyle(
                fontFamily: "Bahnschrift",
                color: Colors.white,
                fontSize: 17.0,
                fontWeight: FontWeight.w500),
          )),
      onGenerateRoute: RouteGenerator.generateRoute,
      navigatorKey: navigator,
    );
  }
}

class ChangeLang with ChangeNotifier {}
