import 'package:flutter/material.dart';
import 'package:qr_code_app/core/extensions/context/app_text_theme_extension.dart';
import 'package:qr_code_app/core/widgets/back_widget.dart';
import 'package:qr_code_app/features/history/data_source/models/gen_box/gen_box_model.dart';
import 'package:qr_code_app/features/generate/presentation/widgets/containers/single_field_container.dart';

/// Hosts the selected QR generation form.
class QrGeneratePage extends StatelessWidget {
  /// Form widget that collects the selected QR payload data.
  final Widget generateContainer;

  /// Metadata for the selected generation type.
  final GenBox genBox;

  /// Creates a generation page for [genBox].
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
        title: Text(
          genBox.name,
          style: context.textTheme.headlineLarge,
        ),
        leading: BackWidget(),
      ),
      body: (generateContainer is SingleFieldContainer) || genBox.name == "Wi-Fi"
          ? Center(child: generateContainer)
          : Center(child: SingleChildScrollView(child: generateContainer)),
    );
  }
}
