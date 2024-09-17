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
        title: Text(genBox.name),
        
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
