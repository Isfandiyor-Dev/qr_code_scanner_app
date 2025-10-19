import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:qr_code_scanner_app/core/extensions/context/app_text_theme_extension.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_bloc.dart';
import 'package:qr_code_scanner_app/features/history/presentation/bloc/history/history_event.dart';
import 'package:qr_code_scanner_app/features/generate/presentation/widgets/other/custom_textfield.dart';
import 'package:qr_code_scanner_app/features/generate/presentation/widgets/other/generate_button.dart';
import 'package:qr_code_scanner_app/features/result_screen/presentation/result_page.dart';
import 'package:svg_flutter/svg.dart';

import '../../../../../core/enums/result_screen.dart';

class BusinessContainer extends StatefulWidget {
  final String iconPath;

  const BusinessContainer({super.key, required this.iconPath});

  @override
  State<BusinessContainer> createState() => _BusinessContainerState();
}

class _BusinessContainerState extends State<BusinessContainer> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController industryController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  void dispose() {
    companyNameController.dispose();
    industryController.dispose();
    phoneController.dispose();
    emailController.dispose();
    websiteController.dispose();
    addressController.dispose();
    cityController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // 🔹 Form bilan validatsiyani bog‘ladik
      child: Container(
        margin: const EdgeInsets.all(25),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.colorScheme.secondaryContainer.withValues(alpha: 0.78),
          borderRadius: BorderRadius.circular(10),
          border: Border.symmetric(
            horizontal: BorderSide(color: context.colorScheme.primary),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(widget.iconPath, height: 64, width: 64),
            const Gap(20),

            // ✅ Majburiy maydonlar
            CustomTextField(
              hintText: "Enter name",
              fieldLabel: 'Company Name *',
              controller: companyNameController,
              validator: (value) => value == null || value.isEmpty
                  ? "Company name required"
                  : null,
            ),
            CustomTextField(
              hintText: "e.g Food/Agency",
              fieldLabel: 'Industry *',
              controller: industryController,
              validator: (value) =>
                  value == null || value.isEmpty ? "Industry required" : null,
            ),
            CustomTextField(
              hintText: "Enter phone",
              fieldLabel: 'Phone *',
              controller: phoneController,
              keyboardType: TextInputType.phone,
              validator: (value) =>
                  value == null || value.isEmpty ? "Phone required" : null,
            ),

            // 🟡 Optional maydonlar
            CustomTextField(
              hintText: "Enter email",
              fieldLabel: 'Email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              hintText: "Enter website",
              fieldLabel: 'Website',
              controller: websiteController,
            ),
            CustomTextField(
              hintText: "Enter address",
              fieldLabel: 'Address',
              controller: addressController,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: "Enter city",
                    fieldLabel: 'City',
                    controller: cityController,
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: CustomTextField(
                    hintText: "Enter country",
                    fieldLabel: 'Country',
                    controller: countryController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🔘 Tugma
            GenerateButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Map<String, dynamic> data = {};

                  // required fields
                  data["Company Name"] = companyNameController.text.trim();
                  data["Industry"] = industryController.text.trim();
                  data["Phone"] = phoneController.text.trim();

                  // optional fields (faqat to‘lgan bo‘lsa qo‘shiladi)
                  void addIfNotEmpty(String key, String value) {
                    if (value.trim().isNotEmpty) data[key] = value.trim();
                  }

                  addIfNotEmpty("Email", emailController.text);
                  addIfNotEmpty("Website", websiteController.text);
                  addIfNotEmpty("Address", addressController.text);
                  addIfNotEmpty("City", cityController.text);
                  addIfNotEmpty("Country", countryController.text);

                  // Bloc event
                  BlocProvider.of<HistoryBloc>(context).add(
                    AddHistoryEvent(
                      code: jsonEncode(data),
                      isGenerated: true,
                    ),
                  );

                  // Navigate to result page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultPage(
                        qrCode: jsonEncode(data),
                        fromScreen: FromScreenEnum.generated,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
