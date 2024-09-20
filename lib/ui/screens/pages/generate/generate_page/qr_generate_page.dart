import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/data/models/gen_box/gen_box_model.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/containers/single_field_container.dart';

class QrGeneratePage extends StatelessWidget {
  final Widget generateContainer;
  final GenBox genBox;
  const QrGeneratePage({
    super.key,
    required this.generateContainer,
    required this.genBox,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 80,
        title: Text(genBox.name),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xff333333),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff000000).withOpacity(0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xffFDB623),
              ),
            ),
          ),
        ),
      ),
      body:
          (generateContainer is SingleFieldContainer) || genBox.name == "Wi-Fi"
              ? Center(child: generateContainer)
              : SingleChildScrollView(
                  child: Center(child: generateContainer),
                ),
    );
  }
}
