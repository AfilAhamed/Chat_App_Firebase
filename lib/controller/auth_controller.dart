import 'package:chat_app/services/auth_services.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final TextEditingController numberController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

 

  //login using phone number
  loginWithPhone(
    context,
  ) {
    AuthServices().loginWithPhoneNumber(
        context, "+${selectedCountry.phoneCode}${numberController.text}");
    notifyListeners();
  }

  //otp submition
  Future<void> onOtpSumbit(verificationId) async {
    await AuthServices().otpSumbit(otpController.text, verificationId);
  }

  //login using google
  Future<UserCredential?> loginWithGoogle(context) {
    return AuthServices().handleGoogleBtnClick(context);
  }

  // signOut from the app
  Future<void> signOut() async {
    await AuthServices().signOutUserAccount();
  }


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
