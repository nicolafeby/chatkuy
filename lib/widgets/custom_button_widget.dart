import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final double? width;
  final double? height;
  const CustomButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
