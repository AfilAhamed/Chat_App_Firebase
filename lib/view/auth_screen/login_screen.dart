import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/view/auth_screen/widgets/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/decorations.dart';

class UserLoginScreen extends StatelessWidget {
  UserLoginScreen({super.key});
  final TextEditingController numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
                  style: GoogleFonts.aDLaMDisplay(
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
                    controller: numberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a Phone number';
                      } else {
                        return null;
                      }
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: inputDecration(
                      'Phone Number',
                      Icons.phone,
                    ),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OtpScreen(
                                            phoneNumber: numberController.text,
                                          )));
                            }
                          },
                          child: Text(
                            'Sign in',
                            style: GoogleFonts.mali(
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
                        AuthServices().signInWithGoogle();
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
