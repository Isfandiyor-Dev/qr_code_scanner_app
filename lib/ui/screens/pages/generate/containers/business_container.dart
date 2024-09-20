import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_app/blocs/history/history_bloc.dart';
import 'package:qr_code_scanner_app/blocs/history/history_event.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/widgets/custom_textfield.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/widgets/generate_button.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/scanner/result_page/result_page.dart';
import 'package:svg_flutter/svg.dart';

class BusinessContainer extends StatefulWidget {
  final String iconPath;

  const BusinessContainer({super.key, required this.iconPath});

  @override
  State<BusinessContainer> createState() => _BusinessContainerState();
}

class _BusinessContainerState extends State<BusinessContainer> {
  // Define TextEditingControllers for each TextField
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController industryController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[800]!.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
        border: const Border.symmetric(
          horizontal: BorderSide(color: Colors.amber),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // SVG Icon at the top
          SvgPicture.asset(
            widget.iconPath,
            height: 64,
            width: 64,
          ),
          const SizedBox(height: 20),
          CustomTextField(
            hintText: "",
            fieldLabel: 'Company Name',
            controller: companyNameController,
          ),
          CustomTextField(
            hintText: "",
            fieldLabel: 'Industry',
            controller: industryController,
          ),
          CustomTextField(
            hintText: "",
            fieldLabel: 'Phone',
            controller: phoneController,
          ),
          CustomTextField(
            hintText: "",
            fieldLabel: 'Email',
            controller: emailController,
          ),
          CustomTextField(
            hintText: "",
            fieldLabel: 'Website',
            controller: websiteController,
          ),
          CustomTextField(
            hintText: "",
            fieldLabel: 'Address',
            controller: addressController,
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  hintText: "",
                  fieldLabel: 'City',
                  controller: cityController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  hintText: "",
                  fieldLabel: 'Country',
                  controller: countryController,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GenerateButton(onPressed: () {
            Map<String, dynamic> data = {
              "Company Name": companyNameController.text,
              "Industry": industryController.text,
              "Phone": phoneController.text,
              "Email": emailController.text,
              "Website": websiteController.text,
              "Address": addressController.text,
              "City": cityController.text,
              "Country": countryController.text,
            };
            BlocProvider.of<HistoryBloc>(context).add(
              AddHistoryEvent(
                code: jsonEncode(data),
                isGenerated: true,
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultPage(
                  qrCode: jsonEncode(data),
                  isGenerated: true,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
