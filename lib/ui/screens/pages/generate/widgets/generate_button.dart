import 'package:flutter/material.dart';

class GenerateButton extends StatelessWidget {
  final void Function() onPressed;
  const GenerateButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.amber,
        fixedSize: const Size(200, 50),
      ),
      onPressed: onPressed,
      child: const Text(
        "Generate QR Code",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
