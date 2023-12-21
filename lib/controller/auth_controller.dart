import 'package:chat_app/services/auth_services.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final TextEditingController numberController = TextEditingController();

  // country picker
  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  //login using phone number
  loginWithPhone(context, phoneNumber) {
    AuthServices().loginWithPhoneNumber(
        context, "+${selectedCountry.phoneCode}$phoneNumber");
    notifyListeners();
  }

  //login using google
  Future<UserCredential?> loginWithGoogle() {
    return AuthServices().signInWithGoogle();
  }

  // signOut from the app
  Future<void> signOut() async {
    await AuthServices().signOutUserAccount();
  }

  //to change country
  changeCountry(value) {
    selectedCountry = value;
    notifyListeners();
  }

  // controllerValueUpdate(value) {
  //   numberController.text = value;
  //   notifyListeners();
  // }
}
