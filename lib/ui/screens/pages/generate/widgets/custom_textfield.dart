import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String fieldLabel;
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.fieldLabel,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              fieldLabel,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          cursorColor: Colors.white,
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            fillColor: const Color(0xff333333).withOpacity(0.8),
            filled: true,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffD9D9D9),
                width: 0.8,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.amber,
                width: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
