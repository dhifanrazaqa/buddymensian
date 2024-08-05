import 'package:flutter/material.dart';

class OutlinedBtnWidget extends StatelessWidget {
  final Color borderColor;
  final Widget child;
  final VoidCallback handler;
  const OutlinedBtnWidget(
      {super.key,
      required this.borderColor,
      required this.child,
      required this.handler});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: handler,
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          side: BorderSide(color: borderColor, width: 2),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          minimumSize: const Size(double.infinity, 60),
          backgroundColor: Colors.white,
        ),
        child: child);
  }
}
