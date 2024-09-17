import 'package:flutter/material.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/widgets/custom_textfield.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/widgets/generate_button.dart';
import 'package:svg_flutter/svg.dart';

class ContactContainer extends StatefulWidget {
  final String iconPath;

  const ContactContainer({super.key, required this.iconPath});

  @override
  State<ContactContainer> createState() => _ContactContainerState();
}

class _ContactContainerState extends State<ContactContainer> {
  // TextEditingControllers for each input field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(widget.iconPath),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    fieldLabel: 'First Name',
                    controller: nameController,
                    hintText: 'Enter name',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    fieldLabel: 'Last Name',
                    controller: lastNameController,
                    hintText: 'Enter last name',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    fieldLabel: 'Company',
                    controller: companyController,
                    hintText: 'Enter company',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    fieldLabel: 'Job',
                    controller: jobController,
                    hintText: 'Enter job',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    fieldLabel: 'Phone',
                    controller: phoneController,
                    hintText: 'Enter phone',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    fieldLabel: 'Email',
                    controller: emailController,
                    hintText: 'Enter email',
                  ),
                ),
              ],
            ),
            CustomTextField(
              fieldLabel: 'Website',
              controller: websiteController,
              hintText: 'Enter website',
            ),
            CustomTextField(
              fieldLabel: 'Address',
              controller: addressController,
              hintText: 'Enter address',
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    fieldLabel: 'City',
                    controller: cityController,
                    hintText: 'Enter city',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    fieldLabel: 'Country',
                    controller: countryController,
                    hintText: 'Enter country',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          GenerateButton(onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
