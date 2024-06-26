import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/view/auth_screen/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key, this.phoneNumber, this.verificationId});
  final String? phoneNumber;
  final String? verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserLoginScreen()));
            },
            icon: const Icon(Icons.arrow_back_rounded)),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          width: double.infinity,
          child: Column(
            children: [
              const Text(
                'Verification',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: const Text('Enter the code sent to your number',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    )),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 40),
                child: Text('+91 $phoneNumber',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ),
              Consumer<AuthController>(
                builder: (context, provider, child) {
                  return Pinput(
                    controller: provider.otpController,
                    length: 6,
                    defaultPinTheme: PinTheme(
                        width: 56,
                        height: 60,
                        textStyle:
                            const TextStyle(fontSize: 22, color: Colors.black),
                        decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.transparent))),
                    focusedPinTheme: PinTheme(
                        width: 56,
                        height: 60,
                        textStyle:
                            const TextStyle(fontSize: 22, color: Colors.black),
                        decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green))),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Consumer<AuthController>(
                builder: (context, provider, child) {
                  return ElevatedButton(
                      onPressed: () {
                        provider.onOtpSumbit(verificationId);
                      },
                      child: const Text('Verify'));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
