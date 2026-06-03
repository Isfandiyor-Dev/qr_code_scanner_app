import 'dart:convert';
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

/// Form used to generate a location QR code.
class LocationContainer extends StatefulWidget {
  /// Icon displayed above the location form.
  final String iconPath;

  /// Creates a location QR generation form.
  const LocationContainer({super.key, required this.iconPath});

  @override
  State<LocationContainer> createState() => _LocationContainerState();
}

class _LocationContainerState extends State<LocationContainer> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController locationNameController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  @override
  void dispose() {
    locationNameController.dispose();
    stateController.dispose();
    countryController.dispose();
    postalCodeController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  void _generateQRCode() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Map<String, dynamic> data = {
      "Location Name": locationNameController.text,
      "State": stateController.text,
      "Country": countryController.text,
      if (postalCodeController.text.isNotEmpty) "Postal Code": postalCodeController.text,
      if (latitudeController.text.isNotEmpty) "Latitude": latitudeController.text,
      if (longitudeController.text.isNotEmpty) "Longitude": longitudeController.text,
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
          fromScreen: FromScreenEnum.generated,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: context.colorScheme.secondaryContainer.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(10),
        border: Border.symmetric(
          horizontal: BorderSide(color: context.colorScheme.primary),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(widget.iconPath),
            const SizedBox(height: 20),
            CustomTextField(
              fieldLabel: 'Location Name *',
              controller: locationNameController,
              hintText: "Enter location name",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Location name is required";
                }
                return null;
              },
            ),
            CustomTextField(
              fieldLabel: 'State *',
              controller: stateController,
              hintText: "Enter state/region",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "State is required";
                }
                return null;
              },
            ),
            CustomTextField(
              fieldLabel: 'Country *',
              controller: countryController,
              hintText: "Enter country name",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Country is required";
                }
                return null;
              },
            ),
            CustomTextField(
              fieldLabel: 'Postal Code',
              controller: postalCodeController,
              hintText: "Optional",
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    fieldLabel: 'Latitude',
                    controller: latitudeController,
                    hintText: "Optional",
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomTextField(
                    fieldLabel: 'Longitude',
                    controller: longitudeController,
                    hintText: "Optional",
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GenerateButton(onPressed: _generateQRCode),
          ],
        ),
      ),
    );
  }
}
