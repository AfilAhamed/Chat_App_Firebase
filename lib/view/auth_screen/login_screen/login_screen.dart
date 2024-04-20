import 'package:chat_app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'widgets/decorations.dart';
import 'dart:ui'; // Add this line to import FontFeature


class UserLoginScreen extends StatelessWidget {
  const UserLoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final provider = Provider.of<AuthController>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Login',
                  style: GoogleFonts.abel(
                      fontSize: 40, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Please sign in to continue',
                  style: GoogleFonts.nunito(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    controller: provider.numberController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Phone number';
                      } else if (value.length < 10) {
                        return 'Please enter a 10 Digit Number';
                      } else {
                        return null;
                      }
                    },
                    decoration: inputDecration('Enter a phone number', context,
                        provider.numberController),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13)),
                              backgroundColor: Colors.blue.shade700),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              provider.loginWithPhone(context);
                            }
                          },
                          child: Text(
                            'Sign in',
                            style: GoogleFonts.abel(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ))),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Row(
              children: [
                Flexible(
                    child: Divider(
                  color: Colors.grey,
                  thickness: 0.4,
                  endIndent: 5,
                  indent: 20,
                )),
                Text(
                  'Or Sign in with',
                  style: TextStyle(color: Colors.grey),
                ),
                Flexible(
                    child: Divider(
                  color: Colors.grey,
                  thickness: 0.4,
                  indent: 5,
                  endIndent: 20,
                ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(100)),
                  child: IconButton(
                      onPressed: () {
                        provider.loginWithGoogle(context);
                      },
                      icon: const Image(
                          fit: BoxFit.cover,
                          height: 30,
                          image: AssetImage('assets/google-logo.png'))),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(100)),
                  child: IconButton(
                      onPressed: () {},
                      icon: const Image(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/facebook-logo.png'))),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
