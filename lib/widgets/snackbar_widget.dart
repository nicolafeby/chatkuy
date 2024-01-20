import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, Color color, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 14.0),
      ),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Oke',
        onPressed: () {},
        textColor: Colors.white,
      ),
    ),
  );
}
