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
           border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)));
}
