import 'package:flutter/material.dart';

class SnackBarHelper {
  static void showSnackBarWithAction(
    context,
    onPressed, {
    message = 'Error !',
    actionMessage = 'Retry',
    dismissDuration = const Duration(seconds: 5),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      duration: dismissDuration,
      backgroundColor: Colors.black,
      action: SnackBarAction(
        label: actionMessage,
        onPressed: onPressed,
        textColor: Colors.white,
      ),
    ));
  }
}
