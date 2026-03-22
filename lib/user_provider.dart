import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String userName = "";
  String userEmail = "";
  String userNumber = "";
  String countryCode = "";
  String userPass = "";

  UserProvider() {
    loadUserData();
  }

  String getName() => userName;
  String getEmail() => userEmail;
  String getNumber() => userNumber;
  String getCountryCode() => countryCode;
  String getPassword() => userPass;

  void saveUserDate(
    String name,
    String email,
    String number,
    String code,
    String pass,
  ) async {
    userName = name;
    userEmail = email;
    userNumber = number;
    countryCode = code;
    userPass = pass;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('number', number);
    await prefs.setString('code', code);
    await prefs.setString('password', pass);

    notifyListeners();
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('name') ?? "";
    userEmail = prefs.getString('email') ?? "";
    userNumber = prefs.getString('number') ?? "";
    countryCode = prefs.getString('code') ?? "";
    userPass = prefs.getString('password') ?? "";
    notifyListeners();
  }
}
