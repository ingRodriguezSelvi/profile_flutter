import 'package:flutter/material.dart';

class NotificationsService  {
  static GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white,fontSize: 20),),
      duration: const Duration(seconds: 2),
    );
    scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
  }
}