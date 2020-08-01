import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
InputDecoration decorateTxt(String hint , Icon icon , bool passwordMatched) {
  return InputDecoration(
    errorText: !passwordMatched ? 'password not matched' : null,
    prefixIcon: icon,
    labelText: hint,
    labelStyle: textFieldStyle(),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
            color: Colors.greenAccent,
            width: 2
        )
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 2
        )
    ),
  );
}
InputDecoration passwordDecoration(String hint , Icon icon , bool passwordMatched , IconButton suffixIconButton) {
  return InputDecoration(
    errorText: !passwordMatched ? 'password not matched' : null,
    prefixIcon: icon,
    suffixIcon: suffixIconButton,
    labelText: hint,
    labelStyle: textFieldStyle(),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
            color: Colors.greenAccent,
            width: 2
        )
    ),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(
            color: Colors.blueAccent,
            width: 2
        )
    ),
  );
}

TextStyle textFieldStyle() {
  return TextStyle(
      fontSize: 18,
      color: Colors.grey
  );
}
