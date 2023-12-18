import 'package:flutter/material.dart';

// textformField Decoration
InputDecoration inputDecration(text, IconData prefixIcon) {
  return InputDecoration(
      labelText: text,
      labelStyle:
          const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
      prefixIcon: Icon(prefixIcon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)));
}
