import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_app/blocs/history/history_bloc.dart';
import 'package:qr_code_scanner_app/blocs/history/history_event.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/widgets/custom_textfield.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/generate/widgets/generate_button.dart';
import 'package:qr_code_scanner_app/ui/screens/pages/scanner/result_page/result_page.dart';
import 'package:svg_flutter/svg.dart';

class LocationContainer extends StatefulWidget {
  final String iconPath;

  const LocationContainer({super.key, required this.iconPath});

  @override
  State<LocationContainer> createState() => _LocationContainerState();
}

class _LocationContainerState extends State<LocationContainer> {
  // Define TextEditingControllers for each TextField
  final TextEditingController locationNameController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(25),
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
          SvgPicture.asset(widget.iconPath),
          const SizedBox(height: 20),
          CustomTextField(
            fieldLabel: 'Location Name',
            controller: locationNameController,
            hintText: "",
          ),
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                  fieldLabel: 'Latitude',
                  controller: latitudeController,
                  hintText: "",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomTextField(
                  fieldLabel: 'Longitude',
                  controller: longitudeController,
                  hintText: "",
                ),
              ),
            ],
          ),
          CustomTextField(
            fieldLabel: 'Postal Code',
            controller: postalCodeController,
            hintText: "",
          ),
          CustomTextField(
            fieldLabel: 'State',
            controller: stateController,
            hintText: "",
          ),
          CustomTextField(
            fieldLabel: 'Country',
            controller: countryController,
            hintText: "",
          ),
          const SizedBox(height: 20),
          GenerateButton(onPressed: () {
            Map<String, dynamic> data = {
              "Location Name": locationNameController.text,
              "Latitude": latitudeController.text,
              "Longitude": longitudeController.text,
              "Postal Code": postalCodeController.text,
              "State": stateController.text,
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
