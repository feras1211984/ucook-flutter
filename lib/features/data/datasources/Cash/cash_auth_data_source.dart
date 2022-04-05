import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:ucookfrontend/core/error/exceptions.dart';

abstract class TokenCashDataSource {
  void saveToken();
  void savePhone(String vcode);
  void saveVCode(String vcode);
  void saveTmpToken(String token);
  void deleteToken();
  Future<String> getToken();
}

class TokenCashDataSourceImpl implements TokenCashDataSource {
  final SharedPreferences sharedPreferences;
  TokenCashDataSourceImpl(this.sharedPreferences);

  @override
  Future<String> getToken() async {
    String? token = sharedPreferences.getString('token');
    if (token == null)
      throw AuthException();
    else
      return sharedPreferences.getString('token') as String;
  }

  String getTokenAsString() {
    String? token = sharedPreferences.getString('token');
    if (token == null)
      return '';
    else
      return sharedPreferences.getString('token') as String;
  }

  String getTmpTokenAsString() {
    String? token = sharedPreferences.getString('tmpToken');
    if (token == null)
      return '';
    else
      return sharedPreferences.getString('tmpToken') as String;
  }

  String getVCodeAsString() {
    String? vcode = sharedPreferences.getString('vcode');
    if (vcode == null)
      return '';
    else
      return sharedPreferences.getString('vcode') as String;
  }

  @override
  void saveToken() {
    var tempToken = sharedPreferences.getString('tmpToken') ?? '';
    sharedPreferences.setString('token', tempToken);
  }

  String getPhoneAsString() {
    String? phone = sharedPreferences.getString('phone');
    if (phone == null)
      return '';
    else
      return sharedPreferences.getString('phone') as String;
  }

  @override
  void savePhone(String phone) {
    sharedPreferences.setString('phone', phone);
  }

  @override
  void saveVCode(String vcode) {
    sharedPreferences.setString('vcode', vcode);
  }

  @override
  void saveTmpToken(String token) {
    sharedPreferences.setString('tmpToken', token);
  }

  @override
  void deleteToken() {
    sharedPreferences.remove('token');
  }
}
