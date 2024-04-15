import 'package:chat_app/controller/auth_controller.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// textformField Decoration
InputDecoration inputDecration(
    text, context, TextEditingController phoneController) {
  final provider = Provider.of<AuthController>(context);

  return InputDecoration(
      labelText: text,
      labelStyle: const TextStyle(color: Colors.black),
      prefixIcon: Container(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            showCountryPicker(
                context: context,
                countryListTheme: const CountryListThemeData(
                  bottomSheetHeight: 550,
                ),
                onSelect: provider.changeCountry);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              "${provider.selectedCountry.flagEmoji}  + ${provider.selectedCountry.phoneCode}",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      // suffixIcon: phoneController.text.length == 10
      //     ? Container(
      //         height: 10,
      //         width: 10,
      //         decoration: const BoxDecoration(
      //             shape: BoxShape.circle, color: Colors.green),
      //         child: const Icon(
      //           Icons.close,
      //           color: Colors.white,
      //         ),
      //       )
      // : Container(
      //     height: 1,
      //     width: 1,
      //     decoration:
      //         BoxDecoration(shape: BoxShape.circle, color: Colors.red),
      //     child: Icon(
      //       Icons.close,
      //       size: 15,
      //       color: Colors.white,
      //     ),
      //   ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)));
}
