import 'package:flutter/material.dart';

class QrGeneratePage extends StatelessWidget {
  final Widget generateContainer;
  const QrGeneratePage({super.key, required this.generateContainer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.grey[600],
      ),
      body: Center(child: generateContainer),
    );
  }
}
