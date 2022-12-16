import 'package:flutter/material.dart';

class InputDecorations {
  static InputDecoration authInputDecoration({
    required String hinText,
    required String labelText,
    IconData? prefixIcon,
  }) {
    return  InputDecoration(
      labelText: labelText,
      hintText: hinText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide()
      ),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
              width: 2,
              color: Colors.blue
          )
      ),
    );
  }
}