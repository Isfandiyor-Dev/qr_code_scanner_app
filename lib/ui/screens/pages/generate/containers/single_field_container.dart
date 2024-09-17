import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/widgets/custom_textfield.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/widgets/generate_button.dart';
import 'package:svg_flutter/svg.dart';

class SingleFieldContainer extends StatelessWidget {
  final String name;
  final String iconPath;
  final String fieldLabel;

  SingleFieldContainer({
    super.key,
    required this.name,
    required this.iconPath,
    required this.fieldLabel,
  });

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.37,
      width: MediaQuery.of(context).size.width * 0.78,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[800]!.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        border: const Border.symmetric(
          horizontal: BorderSide(color: Colors.amber),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(iconPath),
          CustomTextField(
            fieldLabel: fieldLabel,
            controller: textController,
            hintText: "",
          ),
          GenerateButton(
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
