import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_app/core/extensions/context/app_text_theme_extension.dart';
import 'package:qr_code_app/features/history/presentation/bloc/history/history_bloc.dart';
import 'package:qr_code_app/features/history/presentation/bloc/history/history_event.dart';
import 'package:qr_code_app/features/generate/presentation/widgets/other/custom_textfield.dart';
import 'package:qr_code_app/features/generate/presentation/widgets/other/generate_button.dart';
import 'package:qr_code_app/features/result_screen/presentation/result_page.dart';
import 'package:svg_flutter/svg.dart';

import '../../../../../core/enums/result_screen.dart';

/// Form used to generate a vCard contact QR code.
class ContactContainer extends StatefulWidget {
  /// Icon displayed above the contact form.
  final String iconPath;

  /// Creates a contact QR generation form.
  const ContactContainer({super.key, required this.iconPath});

  @override
  State<ContactContainer> createState() => _ContactContainerState();
}

class _ContactContainerState extends State<ContactContainer> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    companyController.dispose();
    jobController.dispose();
    websiteController.dispose();
    addressController.dispose();
    cityController.dispose();
    countryController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    return phoneRegex.hasMatch(phone);
  }

  String _generateVCard() {
    final List<String> lines = [
      'BEGIN:VCARD',
      'VERSION:3.0',
    ];

    final firstName = nameController.text.trim();
    final lastName = lastNameController.text.trim();
    lines.add('N:$lastName;$firstName;;;');
    lines.add('FN:$firstName $lastName');

    if (phoneController.text.trim().isNotEmpty) {
      lines.add('TEL:${phoneController.text.trim()}');
    }
    if (emailController.text.trim().isNotEmpty) {
      lines.add('EMAIL:${emailController.text.trim()}');
    }
    if (companyController.text.trim().isNotEmpty) {
      lines.add('ORG:${companyController.text.trim()}');
    }
    if (jobController.text.trim().isNotEmpty) {
      lines.add('TITLE:${jobController.text.trim()}');
    }
    if (websiteController.text.trim().isNotEmpty) {
      lines.add('URL:${websiteController.text.trim()}');
    }

    if (addressController.text.trim().isNotEmpty ||
        cityController.text.trim().isNotEmpty ||
        countryController.text.trim().isNotEmpty) {
      final addressParts = [
        '',
        '',
        addressController.text.trim(),
        cityController.text.trim(),
        '',
        '',
        countryController.text.trim(),
      ];
      lines.add('ADR:${addressParts.join(';')}');
    }

    lines.add('END:VCARD');
    return lines.join('\n');
  }

  void _onGenerate() {
    if (!_formKey.currentState!.validate()) return;

    final vCard = _generateVCard();

    BlocProvider.of<HistoryBloc>(context).add(
      AddHistoryEvent(code: vCard, isGenerated: true),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultPage(
          qrCode: vCard,
          fromScreen: FromScreenEnum.generated,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.secondaryContainer.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(10),
        border: Border.symmetric(
          horizontal: BorderSide(color: context.colorScheme.primary),
        ),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: SvgPicture.asset(widget.iconPath)),
              const SizedBox(height: 20),
              CustomTextField(
                fieldLabel: 'First Name *',
                controller: nameController,
                hintText: 'Enter first name',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'First name cannot be empty';
                  }
                  return null;
                },
              ),
              CustomTextField(
                fieldLabel: 'Last Name',
                controller: lastNameController,
                hintText: 'Enter last name',
              ),
              CustomTextField(
                fieldLabel: 'Phone *',
                controller: phoneController,
                hintText: 'Enter phone number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number cannot be empty';
                  }
                  if (!_isValidPhone(value.trim())) {
                    return 'Invalid phone number format';
                  }
                  return null;
                },
              ),
              CustomTextField(
                fieldLabel: 'Email',
                controller: emailController,
                hintText: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final email = value?.trim() ?? '';
                  if (email.isNotEmpty && !_isValidEmail(email)) {
                    return 'Invalid email address';
                  }
                  return null;
                },
              ),
              CustomTextField(
                fieldLabel: 'Company',
                controller: companyController,
                hintText: 'Enter company name',
              ),
              CustomTextField(
                fieldLabel: 'Job',
                controller: jobController,
                hintText: 'Enter job title',
              ),
              CustomTextField(
                fieldLabel: 'Website',
                controller: websiteController,
                hintText: 'Enter website',
                keyboardType: TextInputType.url,
              ),
              CustomTextField(
                fieldLabel: 'Address',
                controller: addressController,
                hintText: 'Enter address',
              ),
              CustomTextField(
                fieldLabel: 'City',
                controller: cityController,
                hintText: 'Enter city',
              ),
              CustomTextField(
                fieldLabel: 'Country',
                controller: countryController,
                hintText: 'Enter country',
              ),
              const SizedBox(height: 20),
              Center(child: GenerateButton(onPressed: _onGenerate)),
            ],
          ),
        ),
      ),
    );
  }
}
